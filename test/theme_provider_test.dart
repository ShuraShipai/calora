import 'package:calora/app/providers/theme_provider.dart';
import 'package:calora/app/services/theme_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('theme provider supports system, light, and dark modes', () {
    final preferences = _FakeThemePreferences();
    final provider = ThemeProvider(preferences: preferences);
    expect(provider.themeMode, ThemeMode.system);

    provider.toggle(Brightness.light);
    expect(provider.themeMode, ThemeMode.dark);

    provider.toggle(Brightness.dark);
    expect(provider.themeMode, ThemeMode.light);

    provider.setThemeMode(ThemeMode.system);
    expect(provider.themeMode, ThemeMode.system);
    expect(preferences.savedModes, <ThemeMode>[
      ThemeMode.dark,
      ThemeMode.light,
      ThemeMode.system,
    ]);
  });

  testWidgets('saved explicit theme is restored while system clears it', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'theme_mode': 'dark',
    });
    final preferences = SharedPreferencesThemePreferencesService();

    expect(await preferences.loadThemeMode(), ThemeMode.dark);

    await preferences.saveThemeMode(ThemeMode.system);
    expect(await preferences.loadThemeMode(), ThemeMode.system);
  });
}

class _FakeThemePreferences implements ThemePreferencesService {
  final savedModes = <ThemeMode>[];

  @override
  Future<ThemeMode> loadThemeMode() async => ThemeMode.system;

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    savedModes.add(themeMode);
  }
}
