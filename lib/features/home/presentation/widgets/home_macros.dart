import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_metrics.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/home/models/home_dashboard.dart';
import 'package:flutter/material.dart';

class HomeMacros extends StatelessWidget {
  const HomeMacros({super.key, required this.dashboard});

  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Align(
          alignment: Alignment.centerLeft,
          child: CaloraSectionTitle('Macros'),
        ),
        CaloraMacroMeter(
          label: 'Protein',
          value: _valueLabel(
            dashboard.proteinGrams,
            dashboard.proteinGoalGrams,
          ),
          filled: dashboard.meterSegmentsFor(
            dashboard.proteinGrams,
            dashboard.proteinGoalGrams,
          ),
          color: context.colors.protein,
        ),
        const SizedBox(height: AppSpacing.xxl),
        CaloraMacroMeter(
          label: 'Carbohydrates',
          value: _valueLabel(
            dashboard.carbohydratesGrams,
            dashboard.carbohydratesGoalGrams,
          ),
          filled: dashboard.meterSegmentsFor(
            dashboard.carbohydratesGrams,
            dashboard.carbohydratesGoalGrams,
          ),
          color: context.colors.carb,
        ),
        const SizedBox(height: AppSpacing.xxl),
        CaloraMacroMeter(
          label: 'Fat',
          value: _valueLabel(dashboard.fatGrams, dashboard.fatGoalGrams),
          filled: dashboard.meterSegmentsFor(
            dashboard.fatGrams,
            dashboard.fatGoalGrams,
          ),
          color: context.colors.fat,
        ),
      ],
    );
  }

  String _valueLabel(int value, int goal) =>
      goal > 0 ? '$value / $goal g' : '$value g';
}
