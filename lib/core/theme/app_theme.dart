import 'package:calora/core/theme/app_colors.dart';
import 'package:calora/core/theme/app_shadows.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
    brightness: Brightness.light,
    colors: AppColors.light,
    shadows: AppShadows.light,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    colors: AppColors.dark,
    shadows: AppShadows.dark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required AppColors colors,
    required AppShadows shadows,
  }) {
    final textTheme = AppTypography.textTheme(colors);
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.moss,
      onPrimary: colors.onAccent,
      primaryContainer: colors.mossTint,
      onPrimaryContainer: colors.mossDeep,
      secondary: colors.fat,
      onSecondary: colors.onAccent,
      secondaryContainer: colors.surfaceAlt,
      onSecondaryContainer: colors.ink,
      error: colors.error,
      onError: colors.onAccent,
      surface: colors.surface,
      onSurface: colors.ink,
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: AppRadii.inputBorder,
      borderSide: BorderSide(color: colors.borderStrong),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.canvas,
      canvasColor: colors.canvas,
      cardColor: colors.surface,
      dividerColor: colors.border,
      disabledColor: colors.inkFaint.withValues(alpha: AppOpacity.disabled),
      splashFactory: InkRipple.splashFactory,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[colors, shadows],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.canvas,
        foregroundColor: colors.ink,
        elevation: AppElevations.none,
        scrolledUnderElevation: AppElevations.none,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
        toolbarHeight: AppSizes.iconButton + AppSpacing.page,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: AppElevations.low,
        margin: EdgeInsets.zero,
        shadowColor: shadows.small.first.color,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardBorder,
          side: BorderSide(color: colors.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: AppStrokes.thin,
        space: AppSpacing.section,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.input,
        ),
        labelStyle: textTheme.labelMedium,
        hintStyle: textTheme.bodyLarge?.copyWith(color: colors.inkFaint),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.moss, width: AppStrokes.scanner),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(
            color: colors.error,
            width: AppStrokes.scanner,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.moss,
          foregroundColor: colors.onAccent,
          disabledBackgroundColor: colors.moss.withValues(
            alpha: AppOpacity.disabled,
          ),
          disabledForegroundColor: colors.onAccent.withValues(
            alpha: AppOpacity.disabled,
          ),
          minimumSize: const Size.fromHeight(46),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.page,
            vertical: AppSpacing.input,
          ),
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.ink,
          backgroundColor: colors.surfaceAlt,
          minimumSize: const Size.fromHeight(46),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.page,
            vertical: AppSpacing.input,
          ),
          side: BorderSide(color: colors.border),
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.moss,
          textStyle: textTheme.bodyMedium?.copyWith(
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colors.ink,
          backgroundColor: colors.surface,
          minimumSize: const Size.square(AppSizes.iconButton),
          side: BorderSide(color: colors.border),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surface,
        selectedColor: colors.moss,
        disabledColor: colors.surfaceAlt,
        side: BorderSide(color: colors.border),
        shape: const StadiumBorder(),
        labelStyle: textTheme.bodySmall?.copyWith(
          fontWeight: AppFontWeights.semiBold,
        ),
        secondaryLabelStyle: textTheme.bodySmall?.copyWith(
          color: colors.onAccent,
          fontWeight: AppFontWeights.semiBold,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        modalBackgroundColor: colors.surface,
        modalBarrierColor: colors.ink.withValues(alpha: AppOpacity.scrim),
        showDragHandle: true,
        dragHandleColor: colors.borderStrong,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        elevation: AppElevations.none,
        indicatorColor: colors.mossTint,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colors.moss
                : colors.inkFaint,
            size: AppSizes.navigationIcon,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return textTheme.labelSmall?.copyWith(
            color: states.contains(WidgetState.selected)
                ? colors.moss
                : colors.inkFaint,
          );
        }),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.moss
              : colors.surfaceAlt;
        }),
        thumbColor: WidgetStatePropertyAll(colors.onAccent),
        trackOutlineColor: WidgetStatePropertyAll(colors.border),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.moss,
        linearTrackColor: colors.surfaceAlt,
        circularTrackColor: colors.surfaceAlt,
      ),
    );
  }
}
