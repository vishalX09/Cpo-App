import 'package:cpu_management/core/constants/enums.dart';
import 'package:cpu_management/core/models/stats/session_stat.dart';
import 'package:cpu_management/core/providers/stats/sse_session_details.dart';
import 'package:cpu_management/core/providers/stats/stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  String? selectedStation;
  String? selectedDateRange;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final stationState = ref.watch(stationStatsProvider);

      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(stationStatsProvider.notifier).fetchStationStats();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Overview Stats",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedStation,
                        hint: const Text('Select Station'),
                        onChanged: (value) {
                          setState(() {
                            selectedStation = value;
                            ref
                                .read(stationStatsProvider.notifier)
                                .fetchStationStats(station: selectedStation);
                          });
                        },
                        items: stationState.stations
                            .map((station) => DropdownMenuItem<String>(
                                  value: station.station.id,
                                  child: Text(station.station.name),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedDateRange,
                        hint: const Text('Select Date Range'),
                        onChanged: (value) {
                          setState(() {
                            selectedDateRange = value;
                            if (value == 'Custom') {
                              // Show date picker dialogs
                            } else {
                              startDate = null;
                              endDate = null;
                            }
                          });
                        },
                        items: DurationType.values
                            .map((range) => DropdownMenuItem<String>(
                                  value: range.value,
                                  child: Text(range.value),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildBody(stationState),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBody(StationStatsState stationState) {
    if (stationState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (stationState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: ${stationState.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(stationStatsProvider.notifier).fetchStationStats();
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
        child: Text('No stats available'),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stationState.stations.length,
              itemBuilder: (context, index) {
                final stationData = stationState.stations[index];
                return _buildStationStatsCard(stationData);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationStatsCard(StationData stationData) {
    final currentSession = stationData.sessionDetails.isNotEmpty
        ? stationData.sessionDetails.first.currentSessionData
        : null;

    if (currentSession == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stationData.station.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(stationData.station.address),
            const SizedBox(height: 16),
            _buildStatsRow(
              "Total Sessions",
              currentSession.totalSessions.toString(),
              Icons.ev_station,
            ),
            _buildStatsRow(
              "Total Amount",
              "₹${currentSession.totalChargedAmount.toStringAsFixed(2)}",
              Icons.currency_rupee,
            ),
            _buildStatsRow(
              "Energy Consumed",
              "${currentSession.totalMeterValue.toStringAsFixed(2)} kWh",
              Icons.electric_bolt,
            ),
            const Divider(height: 24),
            _buildSessionTypeStats(currentSession),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionTypeStats(CurrentSessionData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Session Sources",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildSessionTypePill("App", data.totalAppSessions),
        _buildSessionTypePill("Direct", data.totalDirectSessions),
        _buildSessionTypePill("Web", data.totalWebSessions),
        _buildSessionTypePill("Hub", data.totalHubSessions),
      ],
    );
  }

  Widget _buildSessionTypePill(String type, int count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(type),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // ref.read(stationStatsProvider.notifier).dispose();
    super.dispose();
  }
}
