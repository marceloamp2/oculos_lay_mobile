import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static const double fieldHeight = 56;
  static const double fieldRadius = 14;

  static ThemeData build() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.darkSurface,
      surface: AppColors.lightSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightSurface,
      inputDecorationTheme: _inputDecorationTheme(),
      filledButtonTheme: _filledButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      dividerTheme: const DividerThemeData(
        color: AppColors.fieldBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(fieldRadius),
      borderSide: const BorderSide(color: AppColors.fieldBorder),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fieldBackground,
      hintStyle: const TextStyle(
        color: AppColors.onLightSurfaceMuted,
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.darkSurface, width: 1.4),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: Color(0xFFB3261E)),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: Color(0xFFB3261E), width: 1.4),
      ),
      prefixIconColor: AppColors.onLightSurfaceMuted,
      suffixIconColor: AppColors.onLightSurfaceMuted,
    );
  }

  static FilledButtonThemeData _filledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.lightSurface,
        disabledBackgroundColor: AppColors.darkSurface,
        disabledForegroundColor: AppColors.lightSurface,
        minimumSize: const Size.fromHeight(fieldHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.onLightSurfaceMuted,
        textStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}
