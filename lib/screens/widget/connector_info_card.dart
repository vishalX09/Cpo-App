import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/enums.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          color: (onSelected == true)
              ? ConstantColors.okBg
              : (connector.status == ChargerStatus.available)
                  ? ConstantColors.availableGreen.withOpacity(0.05)
                  : ConstantColors.redBg.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border(
              left: BorderSide(
            color: (onSelected == true)
                ? ConstantColors.okBg
                : (connector.status == ChargerStatus.available)
                    ? ConstantColors.availableGreen
                    : ConstantColors.redBg,
            width: 4,
          ))),
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
                    color: (onSelected == true)
                        ? ConstantColors.white
                        : (connector.status == ChargerStatus.available)
                            ? ConstantColors.availableGreen
                            : ConstantColors.redBg,
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
                        color: (onSelected == true)
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
                    color: (onSelected == true)
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: (onSelected == true)
                              ? ConstantColors.shadeWhite.withOpacity(0.1)
                              : ConstantColors.okBg.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              connector.chargingPointType,
                              style: TextStyle(
                                color: (onSelected == true)
                                    ? ConstantColors.white
                                    : ConstantColors.black4,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: (onSelected == true)
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
                              '${trimNumber(connector.maxPower)}kW',
                              style: TextStyle(
                                color: (onSelected == true)
                                    ? ConstantColors.white
                                    : ConstantColors.black4,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: (onSelected == true)
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
                              '${ConstantStrings.ruppee}${trimNumber(connector.minCharges)}/kWh',
                              style: TextStyle(
                                color: (onSelected == true)
                                    ? ConstantColors.white
                                    : ConstantColors.black4,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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
}

String trimNumber(num num) {
  // Round the number to two decimal places
  double rounded = double.parse(num.toStringAsFixed(2));

  // Check if the rounded number is an integer
  return rounded == rounded.toInt()
      ? rounded.toInt().toString()
      : rounded.toString();
}
