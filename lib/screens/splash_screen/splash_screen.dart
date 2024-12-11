import 'package:cpu_management/core/constants/images.dart';
import 'package:cpu_management/core/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ref.read(authProvider).user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ConstantImages.raysUp,
                height: constraints.maxHeight * 0.2,
              ),
              const Spacer(),
              Image.asset(
                ConstantImages.oneCBigLogo,
                height: constraints.maxHeight * 0.3,
              ),
              const Spacer(),
              Image.asset(
                ConstantImages.sloganLogo,
                height: constraints.maxHeight * 0.1,
              ),
              const Spacer(),
              Image.asset(
                ConstantImages.raysDown,
                height: constraints.maxHeight * 0.2,
              ),
            ],
          ),
        );
      }),
    );
  }
}
