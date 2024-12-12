import 'dart:async';
import 'dart:convert';
import 'package:cpu_management/core/api/api_urls.dart';
import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/images.dart';
import 'package:cpu_management/core/models/chargers/charging_station.dart';
import 'package:cpu_management/core/providers/global_provider.dart';
import 'package:cpu_management/screens/pages/chargers/station_details.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ChargingStationState {
  final List<ChargingStation> stations;
  final bool isLoading;
  final String? error;

  ChargingStationState({
    required this.stations,
    this.isLoading = false,
    this.error,
  });

  ChargingStationState copyWith({
    List<ChargingStation>? stations,
    bool? isLoading,
    String? error,
  }) {
    return ChargingStationState(
      stations: stations ?? this.stations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChargingStationNotifier extends StateNotifier<ChargingStationState> {
  ChargingStationNotifier() : super(ChargingStationState(stations: [])) {
    fetchStations();
  }

  StreamSubscription? _sseSubscription;
  http.Client? _client;
  Timer? _reconnectTimer;
  bool _isSSE = false;

  Future<void> fetchStations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final token = Hive.box<String>('user').get('token');
      if (token == null) throw Exception('Authentication token not found');

      _client = http.Client();
      final request = http.Request(
          'GET', Uri.parse('${ApiUrls.baseUrl}/api/v4/cpo/chargers-details'))
        ..headers['Authorization'] = 'Bearer $token';

      final response = await _client!.send(request);
      final contentType = response.headers['content-type'] ?? '';

      _isSSE = contentType.contains('text/event-stream');

      if (_isSSE) {
        _handleSSEStream(response.stream);
      } else {
        final responseBody = await response.stream.bytesToString();
        final json = jsonDecode(responseBody);

        if (json['success'] == true && json['data'] is List) {
          final stations = (json['data'] as List)
              .map((stationJson) => ChargingStation.fromJson(stationJson))
              .toList();
          state = state.copyWith(stations: stations, isLoading: false);
          _setupPolling();
        } else {
          throw Exception('Invalid response format');
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
            final station = ChargingStation.fromJson(json);
            _updateStations(station);
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
        fetchStations();
      });
    }
  }

  void _updateStations(ChargingStation newStation) {
    final currentStations = List<ChargingStation>.from(state.stations);
    final index = currentStations.indexWhere((s) => s.id == newStation.id);

    if (index != -1) {
      currentStations[index] = newStation;
    } else {
      currentStations.add(newStation);
    }

    state = state.copyWith(stations: currentStations);
  }

  void _reconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      fetchStations();
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

class ChargersPage extends ConsumerStatefulWidget {
  const ChargersPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChargersPageState();
}

class _ChargersPageState extends ConsumerState<ChargersPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final stationState = ref.watch(chargingStationProvider);

      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(chargingStationProvider.notifier).fetchStations();
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: _buildAppBar(),
          body: _buildBody(stationState),
        ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(ConstantImages.logo, height: 24, width: 31),
              const SizedBox(width: 9),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CPO Station",
                      style: TextStyle(
                          color: ConstantColors.iconBlack, fontSize: 12)),
                  Text("Management",
                      style: TextStyle(
                          color: ConstantColors.iconBlack, fontSize: 12))
                ],
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Handle notifications
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ConstantColors.okBg.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(64),
                  ),
                  child: const Icon(Icons.notifications_outlined, size: 24),
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                backgroundColor: ConstantColors.okBg,
                radius: 20,
                child: Text(
                  "P",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBody(ChargingStationState stationState) {
    if (stationState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (stationState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${stationState.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(chargingStationProvider.notifier).fetchStations();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (stationState.stations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ev_station_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No charging stations available',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stationState.stations.length,
      itemBuilder: (context, index) {
        final station = stationState.stations[index];
        return _buildStationCard(station);
      },
    );
  }

  Widget _buildStationCard(ChargingStation station) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChargingDetailsCard(
              station: station,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          height: 72,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  station.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: ConstantColors.grey,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // ref.read(chargingStationProvider.notifier).dispose();
    super.dispose();
  }
}
