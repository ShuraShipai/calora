import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ThemePreferencesService {
  Future<ThemeMode> loadThemeMode();
  Future<void> saveThemeMode(ThemeMode themeMode);
}

class SharedPreferencesThemePreferencesService
    implements ThemePreferencesService {
  static const _themeModeKey = 'theme_mode';

  @override
  Future<ThemeMode> loadThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    return switch (preferences.getString(_themeModeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final preferences = await SharedPreferences.getInstance();
    if (themeMode == ThemeMode.system) {
      await preferences.remove(_themeModeKey);
      return;
    }
    await preferences.setString(_themeModeKey, themeMode.name);
  }
}
