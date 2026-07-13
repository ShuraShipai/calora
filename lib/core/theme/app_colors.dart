import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.canvas,
    required this.surface,
    required this.surfaceAlt,
    required this.ink,
    required this.inkSoft,
    required this.inkFaint,
    required this.moss,
    required this.mossDeep,
    required this.mossTint,
    required this.protein,
    required this.carb,
    required this.fat,
    required this.water,
    required this.error,
    required this.border,
    required this.borderStrong,
    required this.onAccent,
    required this.scannerStart,
    required this.scannerEnd,
  });

  static const light = AppColors(
    canvas: Color(0xFFF6F4EC),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEFEDE3),
    ink: Color(0xFF1F2A24),
    inkSoft: Color(0xFF5C6B60),
    inkFaint: Color(0xFF93A19A),
    moss: Color(0xFF3F6B52),
    mossDeep: Color(0xFF2C4E3C),
    mossTint: Color(0xFFE3E8DC),
    protein: Color(0xFFB98A4E),
    carb: Color(0xFFC9A24A),
    fat: Color(0xFF8B5E6B),
    water: Color(0xFF4A7C82),
    error: Color(0xFFB1503F),
    border: Color(0x1A1F2A24),
    borderStrong: Color(0x291F2A24),
    onAccent: Color(0xFFFFFFFF),
    scannerStart: Color(0xFF1B2B21),
    scannerEnd: Color(0xFF0C130F),
  );

  static const dark = AppColors(
    canvas: Color(0xFF12160F),
    surface: Color(0xFF1B2119),
    surfaceAlt: Color(0xFF232A21),
    ink: Color(0xFFEEEFE9),
    inkSoft: Color(0xFF9BA89E),
    inkFaint: Color(0xFF66756B),
    moss: Color(0xFF86BB98),
    mossDeep: Color(0xFFA6D3B4),
    mossTint: Color(0xFF212B22),
    protein: Color(0xFFD9AE72),
    carb: Color(0xFFDFC276),
    fat: Color(0xFFB18A96),
    water: Color(0xFF7FB4B9),
    error: Color(0xFFD98A78),
    border: Color(0x17EEEFE9),
    borderStrong: Color(0x29EEEFE9),
    onAccent: Color(0xFFFFFFFF),
    scannerStart: Color(0xFF1B2B21),
    scannerEnd: Color(0xFF0C130F),
  );

  final Color canvas;
  final Color surface;
  final Color surfaceAlt;
  final Color ink;
  final Color inkSoft;
  final Color inkFaint;
  final Color moss;
  final Color mossDeep;
  final Color mossTint;
  final Color protein;
  final Color carb;
  final Color fat;
  final Color water;
  final Color error;
  final Color border;
  final Color borderStrong;
  final Color onAccent;
  final Color scannerStart;
  final Color scannerEnd;

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      inkFaint: Color.lerp(inkFaint, other.inkFaint, t)!,
      moss: Color.lerp(moss, other.moss, t)!,
      mossDeep: Color.lerp(mossDeep, other.mossDeep, t)!,
      mossTint: Color.lerp(mossTint, other.mossTint, t)!,
      protein: Color.lerp(protein, other.protein, t)!,
      carb: Color.lerp(carb, other.carb, t)!,
      fat: Color.lerp(fat, other.fat, t)!,
      water: Color.lerp(water, other.water, t)!,
      error: Color.lerp(error, other.error, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      scannerStart: Color.lerp(scannerStart, other.scannerStart, t)!,
      scannerEnd: Color.lerp(scannerEnd, other.scannerEnd, t)!,
    );
  }
}
