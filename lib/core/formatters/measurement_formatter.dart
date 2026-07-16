import 'package:calora/core/models/user_profile.dart';

/// Converts canonical metric values only at form and display boundaries.
class MeasurementFormatter {
  const MeasurementFormatter._();

  static const double _poundsPerKilogram = 2.2046226218;
  static const double _ouncesPerMillilitre = 0.0338140227;

  static bool isImperial(UnitSystem? unitSystem) =>
      unitSystem == UnitSystem.imperial;

  static double weightFromKg(double kilograms, UnitSystem? unitSystem) =>
      isImperial(unitSystem) ? kilograms * _poundsPerKilogram : kilograms;

  static double weightToKg(double value, UnitSystem? unitSystem) =>
      isImperial(unitSystem) ? value / _poundsPerKilogram : value;

  static double waterFromMillilitres(int millilitres, UnitSystem? unitSystem) =>
      isImperial(unitSystem)
      ? millilitres * _ouncesPerMillilitre
      : millilitres / 1000;

  static int waterToMillilitres(double value, UnitSystem? unitSystem) =>
      (isImperial(unitSystem) ? value / _ouncesPerMillilitre : value * 1000)
          .round();

  static String weight(double? kilograms, UnitSystem? unitSystem) {
    if (kilograms == null) return '—';
    final value = weightFromKg(kilograms, unitSystem);
    return '${value.toStringAsFixed(1)} ${isImperial(unitSystem) ? 'lb' : 'kg'}';
  }

  static String water(int millilitres, UnitSystem? unitSystem) {
    if (isImperial(unitSystem)) {
      return '${waterFromMillilitres(millilitres, unitSystem).toStringAsFixed(0)} fl oz';
    }
    return '${(millilitres / 1000).toStringAsFixed(1)} L';
  }

  static String height(double? centimetres, UnitSystem? unitSystem) {
    if (centimetres == null) return '—';
    if (!isImperial(unitSystem)) return '${centimetres.toStringAsFixed(0)} cm';
    final totalInches = (centimetres / 2.54).round();
    return '${totalInches ~/ 12}′ ${totalInches % 12}″';
  }

  static double heightToCm(double value, UnitSystem? unitSystem) =>
      isImperial(unitSystem) ? value * 2.54 : value;

  static double heightFromCm(double centimetres, UnitSystem? unitSystem) =>
      isImperial(unitSystem) ? centimetres / 2.54 : centimetres;
}
