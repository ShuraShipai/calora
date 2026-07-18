import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/formatters/measurement_formatter.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/profile/presentation/widgets/goal_edit_sheet.dart';
import 'package:calora/features/profile/presentation/widgets/goals_list.dart';
import 'package:calora/features/profile/presentation/widgets/profile_page_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthProvider>().profile;
    return Scaffold(
      key: const ValueKey<String>('goals'),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const ProfilePageHeader(title: 'Goals'),
            ProfileSection(
              child: GoalsList(
                profile: profile,
                onEdit: (title, value, unit) =>
                    _showEditor(context, title, value, unit),
              ),
            ),
            const SizedBox(height: AppSpacing.section),
          ],
        ),
      ),
    );
  }

  void _showEditor(
    BuildContext context,
    String title,
    String value,
    String unit,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: GoalEditSheet(
          title: title,
          value: value,
          onSave: (value) => _saveGoal(context, title, value, unit),
        ),
      ),
    );
  }

  Future<bool> _saveGoal(
    BuildContext context,
    String title,
    double value,
    String unit,
  ) async {
    final auth = context.read<AuthProvider>();
    final details = auth.profile?.onboarding ?? const OnboardingDetails();
    final updatedDetails = switch (title) {
      'Daily calorie goal' => details.copyWith(
        dailyCalorieTarget: value.round(),
      ),
      'Protein goal' => details.copyWith(proteinGoalGrams: value.round()),
      'Carbohydrate goal' => details.copyWith(
        carbohydrateGoalGrams: value.round(),
      ),
      'Fat goal' => details.copyWith(fatGoalGrams: value.round()),
      'Water goal' => details.copyWith(
        waterGoalLiters:
            MeasurementFormatter.waterToMillilitres(
              value,
              unit == 'fl oz' ? UnitSystem.imperial : UnitSystem.metric,
            ) /
            1000,
      ),
      'Target weight' => details.copyWith(
        targetWeightKg: MeasurementFormatter.weightToKg(
          value,
          unit == 'lb' ? UnitSystem.imperial : UnitSystem.metric,
        ),
      ),
      'Weekly weight goal' => details.copyWith(
        weeklyWeightGoalKg: MeasurementFormatter.weightToKg(
          value,
          unit.startsWith('lb') ? UnitSystem.imperial : UnitSystem.metric,
        ),
      ),
      _ => details,
    };
    final saved = await auth.updateProfile(
      name: auth.profile?.name ?? '',
      details: updatedDetails,
    );
    if (!context.mounted || !saved) return false;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Goal saved')));
    return true;
  }
}
