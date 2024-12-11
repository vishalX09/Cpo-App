import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/models/chargers/charging_station.dart';
import 'package:cpu_management/screens/widget/connector_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChargingDetailsCard extends ConsumerStatefulWidget {
  final ChargingStation station;
  const ChargingDetailsCard({super.key, required this.station});

  @override
  // ignore: library_private_types_in_public_api
  _ChargingDetailsCardState createState() => _ChargingDetailsCardState();
}

class _ChargingDetailsCardState extends ConsumerState<ChargingDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.name),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Write your refresh logic here
          await Future.delayed(const Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildChargersList(widget.station.chargers),
              // You can add more sections below the chargers list if needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChargersList(List<Charger> chargers) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chargers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: chargers.length,
            itemBuilder: (context, index) {
              final charger = chargers[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ConnectorInfoCard(connector: charger),
              );
            },
          ),
        ],
      ),
    );
  }
}
