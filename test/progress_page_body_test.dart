import 'package:calora/core/theme/app_theme.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:calora/features/progress/presentation/widgets/progress_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('swipes the daily card without showing range controls', (
    tester,
  ) async {
    var previousDayRequests = 0;
    var nextDayRequests = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ProgressPageBody(
            onPreviousDay: () => previousDayRequests++,
            onNextDay: () => nextDayRequests++,
            calorieProgress: 0.6,
            calorieGoal: 2000,
            waterValues: const <double>[0.2, 0.4, 0.6],
            weightValues: const <double>[0.4, 0.6],
            waterLabels: const <String>['Mon', 'Tue', 'Wed'],
            weightLabel: 'Last 7 days · 68.4 kg',
            averageCalories: 1800,
            proteinAverage: 100,
            carbohydrateAverage: 200,
            fatAverage: 60,
            proteinFilled: 5,
            carbohydrateFilled: 5,
            fatFilled: 5,
          ),
        ),
      ),
    );

    expect(find.text('Daily'), findsNothing);
    expect(find.text('Week'), findsNothing);
    expect(find.text('Last 7 days · 68.4 kg'), findsOneWidget);
    expect(find.byType(CaloraProgressRing), findsOneWidget);

    final dailyCard = find.byKey(const ValueKey<String>('daily-calorie-swipe'));

    await tester.drag(dailyCard, const Offset(120, 0));
    await tester.pump();
    expect(previousDayRequests, 1);

    await tester.drag(dailyCard, const Offset(-120, 0));
    await tester.pump();
    expect(nextDayRequests, 1);
  });
}
