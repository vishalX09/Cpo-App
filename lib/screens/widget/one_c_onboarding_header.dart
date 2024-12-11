import 'package:cpu_management/core/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OneCOnboardingHeader extends StatelessWidget {
  const OneCOnboardingHeader({
    super.key,
    this.isVerifyScreen = false,
  });

  final bool isVerifyScreen;

  @override
  Widget build(BuildContext context) {
    // var style = const TextStyle(
    //   fontSize: 24,
    //   fontWeight: FontWeight.w700,
    // );
    return Column(
      children: [
        Image.asset(
          ConstantImages.raysUp,
          height: 20.h,
        ),
        Image.asset(
          ConstantImages.oneCLogoRed2,
          height: 12.h,
        ),
        const Center(
          child: Text(
            "CPO Station Management App",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
