import 'package:calora/features/auth/presentation/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('auth validators reject incomplete credentials', () {
    expect(AuthValidators.requiredName(''), isNotNull);
    expect(AuthValidators.email('not-an-email'), isNotNull);
    expect(AuthValidators.password('12345'), isNotNull);
  });

  test('auth validators accept valid credentials', () {
    expect(AuthValidators.requiredName('Aanya'), isNull);
    expect(AuthValidators.email('aanya@example.com'), isNull);
    expect(AuthValidators.password('steady-meals'), isNull);
  });
}
