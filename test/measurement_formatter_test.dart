import 'package:calora/core/formatters/measurement_formatter.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'converts canonical metric measurements for imperial display and input',
    () {
      expect(MeasurementFormatter.weight(10, UnitSystem.imperial), '22.0 lb');
      expect(
        MeasurementFormatter.weightToKg(22.046226218, UnitSystem.imperial),
        closeTo(10, 0.0001),
      );
      expect(MeasurementFormatter.water(1000, UnitSystem.imperial), '34 fl oz');
      expect(
        MeasurementFormatter.waterToMillilitres(
          33.8140227,
          UnitSystem.imperial,
        ),
        1000,
      );
    },
  );
}
