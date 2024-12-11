import 'dart:async';
import 'dart:convert';

import 'package:cpu_management/core/api/api_urls.dart';
import 'package:cpu_management/core/constants/enums.dart';
import 'package:cpu_management/core/models/stats/session_stat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class StationStatsState {
  final List<StationData> stations;
  final bool isLoading;
  final String? error;

  StationStatsState({
    required this.stations,
    this.isLoading = false,
    this.error,
  });

  StationStatsState copyWith({
    List<StationData>? stations,
    bool? isLoading,
    String? error,
  }) {
    return StationStatsState(
      stations: stations ?? this.stations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class StationStatsNotifier extends StateNotifier<StationStatsState> {
  StationStatsNotifier() : super(StationStatsState(stations: [])) {
    fetchStationStats();
  }

  StreamSubscription? _sseSubscription;
  http.Client? _client;
  Timer? _reconnectTimer;
  bool _isSSE = false;

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
          state =
              state.copyWith(stations: stationResponse.data, isLoading: false);
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
              state = state.copyWith(stations: stationResponse.data);
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

  @override
  void dispose() {
    _sseSubscription?.cancel();
    _client?.close();
    _reconnectTimer?.cancel();
    super.dispose();
  }
}
