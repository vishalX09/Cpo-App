import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/images.dart';
import 'package:flutter/material.dart';

class OneCConnectorImage extends StatelessWidget {
  const OneCConnectorImage({
    super.key,
    this.image,
    this.color = ConstantColors.lightGrey,
    this.height = 24.0,
  });

  final String? image;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (image != null && image!.isNotEmpty) {
      if (image!.startsWith('http://') || image!.startsWith('https://')) {
        return Image.network(
          image!,
          height: height,
          width: height,
          color: color,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              ConstantImages.connectorGrey,
              height: height,
              width: height,
              color: color,
            );
          },
        );
      }
      return Image.asset(
        image!,
        height: height,
        width: height,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            ConstantImages.connectorGrey,
            height: height,
            width: height,
            color: color,
          );
        },
      );
    } else {
      return Image.asset(
        ConstantImages.connectorGrey,
        height: height,
        width: height,
        color: color,
      );
    }
  }
}
