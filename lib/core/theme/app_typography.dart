import 'package:calora/core/theme/app_colors.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const bodyFamily = 'Inter';
  static const displayFamily = 'Fraunces';

  static TextTheme textTheme(AppColors colors) {
    final base = TextTheme(
      titleMedium: _body(
        colors,
        AppFontSizes.control,
        weight: AppFontWeights.semiBold,
      ),
      bodyLarge: _body(colors, AppFontSizes.control),
      bodyMedium: _body(colors, AppFontSizes.body),
      bodySmall: _body(colors, AppFontSizes.label, color: colors.inkSoft),
      labelLarge: _body(
        colors,
        AppFontSizes.control,
        weight: AppFontWeights.semiBold,
      ),
      labelMedium: _body(
        colors,
        AppFontSizes.sectionLabel,
        weight: AppFontWeights.semiBold,
        color: colors.inkSoft,
      ),
      labelSmall: _body(
        colors,
        AppFontSizes.nav,
        weight: AppFontWeights.semiBold,
        color: colors.inkFaint,
      ),
    );

    return base.copyWith(
      displayLarge: TextStyle(
        fontFamily: displayFamily,
        fontSize: AppFontSizes.displayLarge,
        fontWeight: AppFontWeights.semiBold,
        color: colors.ink,
      ),
      headlineLarge: TextStyle(
        fontFamily: displayFamily,
        fontSize: AppFontSizes.display,
        fontWeight: AppFontWeights.semiBold,
        color: colors.ink,
      ),
      headlineMedium: TextStyle(
        fontFamily: displayFamily,
        fontSize: AppFontSizes.onboardingTitle,
        fontWeight: AppFontWeights.semiBold,
        color: colors.ink,
      ),
      headlineSmall: TextStyle(
        fontFamily: displayFamily,
        fontSize: AppFontSizes.pageTitle,
        fontWeight: AppFontWeights.semiBold,
        color: colors.ink,
      ),
      titleLarge: TextStyle(
        fontFamily: displayFamily,
        fontSize: AppFontSizes.sheetTitle,
        fontWeight: AppFontWeights.semiBold,
        color: colors.ink,
      ),
    );
  }

  static TextStyle _body(
    AppColors colors,
    double size, {
    FontWeight weight = AppFontWeights.regular,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: bodyFamily,
      fontSize: size,
      fontWeight: weight,
      color: color ?? colors.ink,
      letterSpacing: 0,
    );
  }
}
