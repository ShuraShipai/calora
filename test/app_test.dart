import 'dart:async';

import 'package:calora/app/calora_app.dart';
import 'package:calora/app/providers/theme_provider.dart';
import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_colors.dart';
import 'package:calora/core/theme/app_theme.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/home/models/home_dashboard.dart';
import 'package:calora/features/home/providers/home_provider.dart';
import 'package:calora/features/home/services/home_dashboard_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'support/fake_auth_dependencies.dart';

void main() {
  testWidgets('boots into the design splash screen', (tester) async {
    await tester.pumpWidget(_testApp());

    expect(find.text('Calora'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('splash')), findsOneWidget);
  });

  for (final themeMode in <ThemeMode>[ThemeMode.light, ThemeMode.dark]) {
    testWidgets('every design screen opens in $themeMode', (tester) async {
      await tester.pumpWidget(_testApp(themeMode: themeMode));

      for (final routeName in AppRoutes.all.where((route) => route != '/')) {
        final navigator = tester.state<NavigatorState>(find.byType(Navigator));
        unawaited(navigator.pushNamed(routeName));
        await tester.pumpAndSettle();

        expect(
          ModalRoute.of(
            tester.element(find.byType(Scaffold).last),
          )?.settings.name,
          routeName,
        );
        navigator.pop();
        await tester.pumpAndSettle();
      }
    });
  }

  test('themes use Material 3 and expose matching token extensions', () {
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.dark.useMaterial3, isTrue);
    expect(AppTheme.light.extension<AppColors>(), AppColors.light);
    expect(AppTheme.dark.extension<AppColors>(), AppColors.dark);
    expect(AppTheme.light.scaffoldBackgroundColor, AppColors.light.canvas);
    expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.dark.canvas);
  });
}

Widget _testApp({ThemeMode themeMode = ThemeMode.system}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider()..setThemeMode(themeMode),
      ),
      ChangeNotifierProvider<AuthProvider>(
        create: (_) =>
            AuthProvider(FakeAuthService(), FakeUserProfileService()),
      ),
      Provider<HomeDashboardService>(
        create: (_) => _FakeHomeDashboardService(),
      ),
      ChangeNotifierProxyProvider<AuthProvider, HomeProvider>(
        create: (context) => HomeProvider(context.read<HomeDashboardService>()),
        update: (_, auth, home) => home!..updateUser(auth.profile),
      ),
    ],
    child: const CaloraApp(),
  );
}

class _FakeHomeDashboardService implements HomeDashboardService {
  @override
  Stream<HomeDashboard> watchToday({
    required String uid,
    required int calorieGoal,
  }) => Stream<HomeDashboard>.value(
    HomeDashboard.empty(calorieGoal: calorieGoal),
  );
}
