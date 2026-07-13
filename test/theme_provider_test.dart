import 'package:calora/app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('theme provider supports system, light, and dark modes', () {
    final provider = ThemeProvider();
    expect(provider.themeMode, ThemeMode.system);

    provider.toggle(Brightness.light);
    expect(provider.themeMode, ThemeMode.dark);

    provider.toggle(Brightness.dark);
    expect(provider.themeMode, ThemeMode.light);

    provider.setThemeMode(ThemeMode.system);
    expect(provider.themeMode, ThemeMode.system);
  });
}
