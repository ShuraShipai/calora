import 'dart:async';

import 'package:calora/app/calora_app.dart';
import 'package:calora/app/providers/theme_provider.dart';
import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_colors.dart';
import 'package:calora/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('boots into the design splash screen', (tester) async {
    await tester.pumpWidget(_testApp());

    expect(find.text('Calora'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('splash')), findsOneWidget);
  });

  testWidgets('every design screen has a registered route', (tester) async {
    await tester.pumpWidget(_testApp());

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

  test('themes use Material 3 and expose matching token extensions', () {
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.dark.useMaterial3, isTrue);
    expect(AppTheme.light.extension<AppColors>(), AppColors.light);
    expect(AppTheme.dark.extension<AppColors>(), AppColors.dark);
    expect(AppTheme.light.scaffoldBackgroundColor, AppColors.light.canvas);
    expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.dark.canvas);
  });
}

Widget _testApp() {
  return ChangeNotifierProvider<ThemeProvider>(
    create: (_) => ThemeProvider(),
    child: const CaloraApp(),
  );
}
