import 'package:cpu_management/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppTheme {
  BuildContext context;

  AppTheme(this.context) {
    context = context;
  }

  ThemeData theme = ThemeData(
    fontFamily: 'QanelasSoft',
    primaryTextTheme: TextTheme(
      bodyLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
        color: ConstantColors.labelBlack,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
        color: ConstantColors.lightGrey,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
        color: ConstantColors.white,
      ),
      labelSmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12.sp,
        color: ConstantColors.labelBlack,
      ),
      displayLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24.sp,
        color: ConstantColors.white,
      ),
    ),
    primaryColor: ConstantColors.primaryColor,
    splashColor: ConstantColors.primaryColor,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(
          ConstantColors.primaryColor.withOpacity(0.5),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 0.0),
        ),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        side: WidgetStateProperty.all(
          const BorderSide(
            color: ConstantColors.lightGrey,
            width: 1,
          ),
        ),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(ConstantColors.primaryColor),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ConstantColors.primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ConstantColors.primaryColor,
      scrolledUnderElevation: 0,
    ),
    scaffoldBackgroundColor: ConstantColors.pageBgColor,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ConstantColors.primaryColor,
      selectionHandleColor: ConstantColors.primaryColor,
      selectionColor: ConstantColors.primaryColor.withOpacity(0.5),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      fillColor: Colors.red,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ConstantColors.lightGrey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ConstantColors.primaryColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      prefixIconColor: ConstantColors.black2,
    ),
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(
        width: 0.8,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: ConstantColors.primaryColor,
      secondary: ConstantColors.secondaryColor,
    ),
    canvasColor: ConstantColors.white,
  );
}
