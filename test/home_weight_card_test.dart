import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/theme/app_theme.dart';
import 'package:calora/features/home/presentation/widgets/home_weight_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows metric weight values and opens the weight screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        onGenerateRoute: (settings) => MaterialPageRoute<void>(
          builder: (_) => settings.name == AppRoutes.weight
              ? const Scaffold(body: Text('Weight screen'))
              : const Scaffold(
                  body: HomeWeightCard(
                    currentWeightKg: 68.4,
                    targetWeightKg: 60,
                    unitSystem: UnitSystem.metric,
                  ),
                ),
        ),
      ),
    );

    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('68.4 kg · Target 60.0 kg'), findsOneWidget);

    await tester.tap(find.text('Weight'));
    await tester.pumpAndSettle();

    expect(find.text('Weight screen'), findsOneWidget);
  });

  testWidgets('formats weight values using the selected unit system', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: HomeWeightCard(
            currentWeightKg: 68,
            targetWeightKg: 60,
            unitSystem: UnitSystem.imperial,
          ),
        ),
      ),
    );

    expect(find.text('149.9 lb · Target 132.3 lb'), findsOneWidget);
  });
}
