import 'package:calora/core/theme/app_theme.dart';
import 'package:calora/features/profile/presentation/widgets/goals_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens unset goals with an empty value', (tester) async {
    final edits = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: GoalsList(
            profile: null,
            onEdit: (_, value, _) => edits.add(value),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Edit Daily calorie goal'));
    await tester.tap(find.byTooltip('Edit Protein goal'));
    await tester.tap(find.byTooltip('Edit Carbohydrate goal'));
    await tester.tap(find.byTooltip('Edit Fat goal'));

    expect(edits, <String>['', '', '', '']);
  });
}
