import 'dart:async';

import 'package:calora/app/services/theme_preferences_service.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  factory ThemeProvider({
    required ThemePreferencesService preferences,
    ThemeMode initialThemeMode = ThemeMode.system,
  }) => ThemeProvider._(preferences, initialThemeMode);

  ThemeProvider._(this._preferences, this._themeMode);

  final ThemePreferencesService _preferences;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) return;
    _themeMode = value;
    notifyListeners();
    unawaited(_preferences.saveThemeMode(value));
  }

  void toggle(Brightness platformBrightness) {
    final isDark =
        _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            platformBrightness == Brightness.dark);
    setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
