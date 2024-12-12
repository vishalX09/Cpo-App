import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/images.dart';
import 'package:cpu_management/core/constants/strings.dart';
import 'package:cpu_management/core/models/chargers/charging_station.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConnectorInfoCard extends StatelessWidget {
  ConnectorInfoCard({
    super.key,
    required this.connector,
    this.onSelected,
  });
  final Charger connector;
  bool? onSelected = true;

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "available":
        return ConstantColors.availableGreen;
      case "charging":
        return ConstantColors.primaryColor;
      case "offline":
        return ConstantColors.cC;
      case "faulted":
        return ConstantColors.faultyOrange;
      default:
        return ConstantColors.availableGreen;
    }
  }

  Color getBackgroundColor(String status, bool? isSelected) {
    if (isSelected == true) return ConstantColors.okBg;

    switch (status.toLowerCase()) {
      case "available":
        return ConstantColors.availableGreen.withOpacity(0.05);
      case "charging":
        return ConstantColors.primaryColor.withOpacity(0.05);
      case "offline":
        return ConstantColors.cC.withOpacity(0.05);
      case "faulted":
        return ConstantColors.faultyOrange.withOpacity(0.05);
      default:
        return ConstantColors.availableGreen.withOpacity(0.05);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(connector.status);
    final backgroundColor = getBackgroundColor(connector.status, onSelected);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: onSelected == true ? ConstantColors.okBg : statusColor,
            width: 4,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connector.status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color:
                        onSelected == true ? ConstantColors.white : statusColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(ConstantImages.chargingPinLogo,
                        height: 24, width: 32),
                    const SizedBox(width: 6),
                    Text(
                      connector.connectorType,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: onSelected == true
                            ? ConstantColors.white
                            : ConstantColors.black2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connector.deviceId,
                  style: TextStyle(
                    color: onSelected == true
                        ? ConstantColors.white
                        : ConstantColors.black4,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildInfoContainer(
                        text: connector.chargingPointType,
                        onSelected: onSelected,
                      ),
                      const SizedBox(width: 6),
                      _buildInfoContainer(
                        text: '${trimNumber(connector.maxPower)}kW',
                        onSelected: onSelected,
                      ),
                      const SizedBox(width: 6),
                      _buildInfoContainer(
                        text:
                            '${ConstantStrings.ruppee}${trimNumber(connector.minCharges)}/kWh',
                        onSelected: onSelected,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer({
    required String text,
    required bool? onSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: onSelected == true
            ? ConstantColors.shadeWhite.withOpacity(0.1)
            : ConstantColors.okBg.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: onSelected == true
                  ? ConstantColors.white
                  : ConstantColors.black4,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String trimNumber(num num) {
  double rounded = double.parse(num.toStringAsFixed(2));
  return rounded == rounded.toInt()
      ? rounded.toInt().toString()
      : rounded.toString();
}
