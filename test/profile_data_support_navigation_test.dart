import 'dart:async';

import 'package:calora/app/calora_app.dart';
import 'package:calora/app/providers/theme_provider.dart';
import 'package:calora/app/router/app_routes.dart';
import 'package:calora/app/services/theme_preferences_service.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'support/fake_auth_dependencies.dart';

void main() {
  testWidgets('Data & support rows open their corresponding screens', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    unawaited(navigator.pushNamed(AppRoutes.profile));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Privacy'), 300);
    await tester.tap(find.text('Privacy'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('privacy')), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Help & support'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('help-support')), findsOneWidget);
  });
}

Widget _testApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(
          preferences: _FakeThemePreferences(),
          initialThemeMode: ThemeMode.light,
        ),
      ),
      ChangeNotifierProvider<AuthProvider>(
        create: (_) =>
            AuthProvider(FakeAuthService(), FakeUserProfileService()),
      ),
    ],
    child: const CaloraApp(),
  );
}

class _FakeThemePreferences implements ThemePreferencesService {
  @override
  Future<ThemeMode> loadThemeMode() async => ThemeMode.light;

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {}
}
