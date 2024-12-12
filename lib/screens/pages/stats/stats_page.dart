import 'package:cpu_management/core/constants/enums.dart';
import 'package:cpu_management/core/models/stats/session_stat.dart';
import 'package:cpu_management/core/providers/global_provider.dart';
import 'package:cpu_management/core/providers/stats/sse_session_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(stationStatsProvider.notifier).fetchStationStats();
  }

  @override
  Widget build(BuildContext context) {
    final stationState = ref.watch(stationStatsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(stationStatsProvider.notifier).fetchStationStats();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Overview Stats",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Dropdowns
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Station Dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: stationState.selectedStation,
                      hint: const Text('Select Station'),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        ref
                            .read(stationStatsProvider.notifier)
                            .updateStation(value);
                      },
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('All Stations'),
                        ),
                        ...stationState.stations
                            .map((station) => DropdownMenuItem<String>(
                                  value: station.station.id,
                                  child: Text(station.station.name),
                                )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Date Range Dropdown
                  Expanded(
                    child: DropdownButtonFormField<DurationType>(
                      value: stationState.selectedDateRange,
                      hint: const Text('Select Date Range'),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) async {
                        if (value == DurationType.customRange) {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            ref
                                .read(stationStatsProvider.notifier)
                                .updateDateRange(
                                  value!,
                                  start: picked.start,
                                  end: picked.end,
                                );
                          }
                        } else if (value != null) {
                          ref
                              .read(stationStatsProvider.notifier)
                              .updateDateRange(value);
                        }
                      },
                      items: DurationType.values
                          .map((type) => DropdownMenuItem<DurationType>(
                                value: type,
                                child: Text(type.value),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Stats Cards
                    _buildStatsCards(stationState),

                    // Graph Section
                    if (stationState.barGroups.isNotEmpty) ...[
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hourly Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      _buildGraph(stationState),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraph(StationStatsState state) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: state.maxEarnings > state.maxEnergy
              ? state.maxEarnings
              : state.maxEnergy,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.grey[800]!,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final hourlyData = state.hourlyData[group.x.toInt()];
                final value =
                    rodIndex == 0 ? hourlyData.earnings : hourlyData.energy;
                final label = rodIndex == 0
                    ? 'Earnings: ₹${value.toStringAsFixed(2)}'
                    : 'Energy: ${value.toStringAsFixed(2)} kWh';
                return BarTooltipItem(
                  label,
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < state.hourlyData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        state.hourlyData[value.toInt()].hour,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text('Earnings (₹)'),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '₹${value.toInt()}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              axisNameWidget: const Text('Energy (kWh)'),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
          ),
          borderData: FlBorderData(show: true),
          barGroups: state.barGroups,
        ),
      ),
    );
  }

  Widget _buildStatsCards(StationStatsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    if (state.currentStatsSearched.isEmpty) {
      return const Center(child: Text('No stats available'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.currentStatsSearched.length,
      itemBuilder: (context, index) {
        return _buildStationStatsCard(state.currentStatsSearched[index]);
      },
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSessionTypePill("App", data.totalAppSessions),
            _buildSessionTypePill("Direct", data.totalDirectSessions),
            _buildSessionTypePill("Web", data.totalWebSessions),
            _buildSessionTypePill("Hub", data.totalHubSessions),
          ],
        ),
      ],
    );
  }

  Widget _buildSessionTypePill(String type, int count) {
    return Container(
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
}
