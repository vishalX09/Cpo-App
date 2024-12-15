import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/images.dart';
import 'package:cpu_management/core/models/chargers/charging_station.dart';
import 'package:cpu_management/screens/pages/chargers/sessions_details.dart';
import 'package:cpu_management/screens/widget/connector_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChargingDetailsCard extends ConsumerWidget {
  final ChargingStation station;

  const ChargingDetailsCard({
    super.key,
    required this.station,
  });

  List<Charger> getSortedChargers(List<Charger> chargers) {
    return List<Charger>.from(chargers)
      ..sort((a, b) {
        final priorities = {
          'charging': 0,
          'available': 1,
          'offline': 2,
          'faulty': 3,
        };
        return (priorities[a.status.toLowerCase()] ?? 4)
            .compareTo(priorities[b.status.toLowerCase()] ?? 4);
      });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedChargers = getSortedChargers(station.chargers);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ConstantColors.iconBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(ConstantImages.logo, height: 24, width: 31),
            const SizedBox(width: 9),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.name,
                  style: const TextStyle(
                    color: ConstantColors.iconBlack,
                    fontSize: 12,
                  ),
                ),
                const Text(
                  "Charging Station",
                  style: TextStyle(
                    color: ConstantColors.iconBlack,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildStatusSummary(sortedChargers),
          Expanded(
            child: _buildChargersList(sortedChargers),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSummary(List<Charger> chargers) {
    final statusCounts = {
      'charging': 0,
      'available': 0,
      'offline': 0,
      'faulty': 0,
    };

    for (var charger in chargers) {
      final status = charger.status.toLowerCase();
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusItem('Charging', statusCounts['charging']!,
              ConstantColors.primaryColor),
          _buildStatusItem('Available', statusCounts['available']!,
              ConstantColors.availableGreen),
          _buildStatusItem(
              'Offline', statusCounts['offline']!, ConstantColors.cC),
          _buildStatusItem(
              'Faulty', statusCounts['faulty']!, ConstantColors.faultyOrange),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: ConstantColors.black4,
          ),
        ),
      ],
    );
  }

  Widget _buildChargersList(List<Charger> chargers) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final charger = chargers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SessionDetailsScreen(
                    deviceId: charger.deviceId,
                    connectorId: charger.connectorId,
                  ),
                ),
              );
            },
            child: ConnectorInfoCard(
              connector: charger,
              onSelected: false,
            ),
          ),
        );
      },
      itemCount: chargers.length,
    );
  }
}
