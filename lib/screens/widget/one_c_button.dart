import 'package:cpu_management/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class OneCButton extends StatelessWidget {
  const OneCButton({
    super.key,
    required this.onPressed,
    required this.width,
    required this.label,
    this.iconColor = ConstantColors.white,
    this.icon,
    required this.labelColor,
    required this.backgroundColor,
    this.borderSide = BorderSide.none,
    this.contentPadding,
    this.height,
    this.suffixWidget,
  });

  final Function onPressed;
  final IconData? icon;
  final double width;
  final double? height;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final BorderSide borderSide;
  final EdgeInsets? contentPadding;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(backgroundColor),
      padding: WidgetStatePropertyAll(
        contentPadding ??
            const EdgeInsets.symmetric(
              vertical: 16,
            ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          side: borderSide,
        ),
      ),
    );
    var labelStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16.sp,
      color: labelColor,
      letterSpacing: 1.5,
    );

    ///
    return SizedBox(
      width: width,
      height: height,
      child: icon != null
          ? ElevatedButton.icon(
              icon: Icon(
                icon,
                color: iconColor,
              ),
              style: buttonStyle,
              onPressed: () {
                onPressed();
              },
              label: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  label,
                  style: labelStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                onPressed();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      label,
                      style: labelStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (suffixWidget != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: suffixWidget!,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
