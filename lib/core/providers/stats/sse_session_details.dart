import 'dart:async';
import 'dart:convert';
import 'package:cpu_management/core/api/api_urls.dart';
import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/enums.dart';
import 'package:cpu_management/core/models/stats/session_stat.dart';
import 'package:cpu_management/core/repository/stats/stats_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class HourlyData {
  final String hour;
  final double earnings;
  final double energy;

  HourlyData({
    required this.hour,
    required this.earnings,
    required this.energy,
  });
}

class StationStatsState {
  final List<StationData> stations;
  final bool isLoading;
  final String? error;
  final List<StationData> currentStatsSearched;
  final List<HourlyData> hourlyData;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedStation;
  final DurationType selectedDateRange;
  final List<BarChartGroupData> barGroups;
  final double maxEarnings;
  final double maxEnergy;

  StationStatsState({
    required this.stations,
    this.isLoading = false,
    this.error,
    required this.currentStatsSearched,
    this.hourlyData = const [],
    this.startDate,
    this.endDate,
    this.selectedStation,
    this.selectedDateRange = DurationType.today,
    this.barGroups = const [],
    this.maxEarnings = 0,
    this.maxEnergy = 0,
  });

  StationStatsState copyWith({
    List<StationData>? stations,
    bool? isLoading,
    String? error,
    List<StationData>? currentStatsSearched,
    List<HourlyData>? hourlyData,
    DateTime? startDate,
    DateTime? endDate,
    String? selectedStation,
    DurationType? selectedDateRange,
    List<BarChartGroupData>? barGroups,
    double? maxEarnings,
    double? maxEnergy,
  }) {
    return StationStatsState(
      stations: stations ?? this.stations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentStatsSearched: currentStatsSearched ?? this.currentStatsSearched,
      hourlyData: hourlyData ?? this.hourlyData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedStation: selectedStation ?? this.selectedStation,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      barGroups: barGroups ?? this.barGroups,
      maxEarnings: maxEarnings ?? this.maxEarnings,
      maxEnergy: maxEnergy ?? this.maxEnergy,
    );
  }
}

class StationStatsNotifier extends StateNotifier<StationStatsState> {
  StationStatsNotifier()
      : super(StationStatsState(stations: [], currentStatsSearched: [])) {
    fetchStationStats();
  }

  StreamSubscription? _sseSubscription;
  http.Client? _client;
  Timer? _reconnectTimer;
  bool _isSSE = false;
  StatsRepository statsRepository = StatsRepository();

  Future<void> fetchStationOverallStats({
    String? station,
    DurationType? type,
    int? startTime,
    int? endTime,
  }) async {
    var res = await statsRepository.getCPOStats(
        station: station, type: type, startTime: startTime, endTime: endTime);
    if (res.data != null) {
      final hourlyData = processHourlyData(res.data);
      final barGroups = createBarGroups(hourlyData);
      final maxValues = calculateMaxValues(hourlyData);

      state = state.copyWith(
        currentStatsSearched: res.data,
        hourlyData: hourlyData,
        barGroups: barGroups,
        maxEarnings: maxValues.$1,
        maxEnergy: maxValues.$2,
      );
    }
  }

  Future<void> fetchStationStats({
    String? station,
    DurationType? type,
    int? startTime,
    int? endTime,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final token = Hive.box<String>('user').get('token');
      if (token == null) throw Exception('Authentication token not found');

      _client = http.Client();
      final queryParameters = <String, String>{};

      if (type == DurationType.customRange) {
        if (startTime == null || endTime == null) {
          throw Exception(
              'startTime and endTime must be provided for custom range');
        }
        queryParameters['startTime'] = startTime.toString();
        queryParameters['endTime'] = endTime.toString();
      }

      final uri = Uri.parse(
              '${ApiUrls.sessionStat}/${station ?? 'all'}/${type ?? DurationType.today}')
          .replace(queryParameters: queryParameters);

      final request = http.Request('GET', uri)
        ..headers['Authorization'] = 'Bearer $token';

      final response = await _client!.send(request);
      final contentType = response.headers['content-type'] ?? '';

      _isSSE = contentType.contains('text/event-stream');

      if (_isSSE) {
        _handleSSEStream(response.stream);
      } else {
        final responseBody = await response.stream.bytesToString();
        final json = jsonDecode(responseBody);

        final stationResponse = StationStatsResponse.fromJson(json);
        if (stationResponse.success) {
          final hourlyData = processHourlyData(stationResponse.data);
          final barGroups = createBarGroups(hourlyData);
          final maxValues = calculateMaxValues(hourlyData);

          state = state.copyWith(
            stations: stationResponse.data,
            currentStatsSearched: stationResponse.data,
            hourlyData: hourlyData,
            barGroups: barGroups,
            maxEarnings: maxValues.$1,
            maxEnergy: maxValues.$2,
            isLoading: false,
            selectedStation: station,
            selectedDateRange: type ?? state.selectedDateRange,
          );
          _setupPolling();
        } else {
          throw Exception(stationResponse.message);
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      _reconnect();
    }
  }

  void _handleSSEStream(Stream<List<int>> stream) {
    _sseSubscription = stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .where((line) => line.isNotEmpty && line.startsWith('data: '))
        .map((line) => line.substring(6))
        .listen(
      (dataString) {
        try {
          final json = jsonDecode(dataString);
          if (json is Map<String, dynamic>) {
            final stationResponse = StationStatsResponse.fromJson(json);
            if (stationResponse.success) {
              final hourlyData = processHourlyData(stationResponse.data);
              final barGroups = createBarGroups(hourlyData);
              final maxValues = calculateMaxValues(hourlyData);

              state = state.copyWith(
                stations: stationResponse.data,
                hourlyData: hourlyData,
                barGroups: barGroups,
                maxEarnings: maxValues.$1,
                maxEnergy: maxValues.$2,
              );
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing SSE data: $e');
          }
        }
      },
      onError: (error) {
        state = state.copyWith(error: error.toString());
        _reconnect();
      },
      cancelOnError: true,
    );
  }

  List<HourlyData> processHourlyData(List<StationData> stationsData) {
    Map<String, HourlyData> hourlyMap = {};

    for (var station in stationsData) {
      for (var sessionDetail in station.sessionDetails) {
        final data = sessionDetail.currentSessionData;
        DateTime dateTime;
        try {
          dateTime = DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(sessionDetail.id ?? '0') ?? 0);
        } catch (e) {
          dateTime = DateTime.now();
        }

        String timeKey = '${dateTime.hour.toString().padLeft(2, '0')}:00';

        if (hourlyMap.containsKey(timeKey)) {
          hourlyMap[timeKey] = HourlyData(
            hour: timeKey,
            earnings: hourlyMap[timeKey]!.earnings + data.totalChargedAmount,
            energy: hourlyMap[timeKey]!.energy + data.totalMeterValue,
          );
        } else {
          hourlyMap[timeKey] = HourlyData(
            hour: timeKey,
            earnings: data.totalChargedAmount,
            energy: data.totalMeterValue,
          );
        }
      }
    }

    var sortedData = hourlyMap.values.toList()
      ..sort((a, b) => a.hour.compareTo(b.hour));

    return sortedData;
  }

  List<BarChartGroupData> createBarGroups(List<HourlyData> hourlyData) {
    return List.generate(hourlyData.length, (index) {
      final data = hourlyData[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.earnings,
            color: ConstantColors.midColorOtpGenrated.withOpacity(0.1),
            width: 8,
          ),
          BarChartRodData(
            toY: data.energy,
            color: ConstantColors.black,
            width: 8,
          ),
        ],
      );
    });
  }

  (double, double) calculateMaxValues(List<HourlyData> hourlyData) {
    double maxEarnings = 0;
    double maxEnergy = 0;

    for (var data in hourlyData) {
      if (data.earnings > maxEarnings) maxEarnings = data.earnings;
      if (data.energy > maxEnergy) maxEnergy = data.energy;
    }

    return (maxEarnings, maxEnergy);
  }

  void _setupPolling() {
    if (!_isSSE) {
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        fetchStationStats();
      });
    }
  }

  void _reconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      fetchStationStats();
    });
  }

  void updateDateRange(DurationType type, {DateTime? start, DateTime? end}) {
    fetchStationStats(
      station: state.selectedStation,
      type: type,
      startTime: start?.millisecondsSinceEpoch,
      endTime: end?.millisecondsSinceEpoch,
    );
  }

  void updateStation(String? stationId) {
    fetchStationStats(
      station: stationId,
      type: state.selectedDateRange,
      startTime: state.startDate?.millisecondsSinceEpoch,
      endTime: state.endDate?.millisecondsSinceEpoch,
    );
  }

  @override
  void dispose() {
    _sseSubscription?.cancel();
    _client?.close();
    _reconnectTimer?.cancel();
    super.dispose();
  }
}
