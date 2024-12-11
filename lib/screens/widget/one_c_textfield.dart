import 'package:cpu_management/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// Custom Textfield
class OneCTextField extends StatelessWidget {
  const OneCTextField({
    super.key,
    this.label,
    this.hintText,
    this.prefixIcon,
    required this.inputType,
    required this.controller,
    this.suffixIcon,
    this.prefixText,
    this.textLimit,
    this.onChanged,
    this.isTextArea = false,
    this.onPrefixTap,
    this.onSuffixTap,
    this.enabled = true,
    this.backgroundColor,
    this.inputFormatters,
  });

  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType inputType;
  final TextEditingController controller;
  final String? prefixText;
  final int? textLimit;
  final void Function(String value)? onChanged;
  final bool isTextArea;
  final Function? onPrefixTap;
  final Function? onSuffixTap;
  final bool enabled;
  final Color? backgroundColor;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (label != null)
          const SizedBox(
            height: 6,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: TextField(
            enabled: enabled,
            onChanged: onChanged,
            controller: controller,
            keyboardType: isTextArea ? TextInputType.multiline : inputType,
            textInputAction: isTextArea ? TextInputAction.newline : null,
            style: prefixText != null
                ? TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  )
                : null,
            inputFormatters: textLimit != null
                ? [
                    LengthLimitingTextInputFormatter(textLimit),
                    ...?inputFormatters
                  ]
                : null,
            maxLines: isTextArea ? 5 : 1,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintText != null
                  ? TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: ConstantColors.lightGrey
                    )
                  : null,
              prefixText: prefixText,
              prefixStyle: prefixText != null
                  ? TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: ConstantColors.black2
                    )
                  : null,
              prefixIcon: (prefixIcon != null)
                  ? GestureDetector(
                      onTap: () {
                        if (onPrefixTap != null) {
                          onPrefixTap!();
                        }
                      },
                      child: Icon(
                        prefixIcon,
                        size: 20,
                        color: enabled
                            ? Theme.of(context).iconTheme.color
                            : ConstantColors.grey,
                      ),
                    )
                  : null,
              suffixIcon: (suffixIcon != null)
                  ? GestureDetector(
                      onTap: () {
                        if (onSuffixTap != null) {
                          onSuffixTap!();
                        }
                      },
                      child: Icon(
                        suffixIcon,
                        size: 20,
                      ),
                    )
                  : null,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: ConstantColors.filterBorderColor),
              ),
              fillColor: backgroundColor,
              filled: backgroundColor != null ? true : false,
            ),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ),
      ],
    );
  }
}
