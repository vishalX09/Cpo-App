import 'dart:math';

import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class OneCOverlay extends StatefulWidget {
  final Widget child;

  const OneCOverlay({super.key, required this.child});

  static void show(BuildContext context) {
    context.loaderOverlay.show();
  }

  static void hide(BuildContext context) {
    context.loaderOverlay.hide();
  }

  @override
  _OneCOverlayState createState() => _OneCOverlayState();
}

class _OneCOverlayState extends State<OneCOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(
        reverse: true); // Continuously repeat the animation back and forth
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (progress) {
        return Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.rotationY(_animation.value * pi),
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: ConstantColors.white,
                  child: Image.asset(
                    ConstantImages.logo,
                  ),
                ),
              );
            },
          ),
        );
      },
      child: widget.child,
    );
  }
}
