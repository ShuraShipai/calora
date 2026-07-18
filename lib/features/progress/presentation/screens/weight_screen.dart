import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/progress/presentation/widgets/log_weight_sheet.dart';
import 'package:calora/features/progress/presentation/widgets/weight_page_body.dart';
import 'package:calora/features/progress/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  Future<void> _showLogWeightSheet(BuildContext context) async {
    final unitSystem = context
        .read<AuthProvider>()
        .profile
        ?.onboarding
        ?.unitSystem;
    final entry = await showCaloraSheet<WeightEntryDraft>(
      context: context,
      showDragHandle: false,
      builder: (_) => LogWeightSheet(unitSystem: unitSystem),
    );
    if (!context.mounted || entry == null) return;
    try {
      await context.read<ProgressProvider>().addWeight(
        weightKg: entry.weightKg,
        loggedAt: entry.loggedAt,
        note: entry.note,
      );
      if (!context.mounted) return;
      showCaloraMessage(context, 'Weight logged');
    } catch (_) {
      if (!context.mounted) return;
      showCaloraMessage(context, 'Could not save weight entry.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final details = context.watch<AuthProvider>().profile?.onboarding;
    final target = details?.targetWeightKg;
    return CaloraScreenScaffold(
      screenId: 'weight',
      title: 'Weight',
      showBackButton: true,
      body: WeightPageBody(
        onLogWeight: () => _showLogWeightSheet(context),
        currentWeightKg: progress.latestWeight?.weightKg,
        targetWeightKg: target,
        hasReachedWeightGoal: _hasReachedWeightGoal(
          currentWeightKg: progress.latestWeight?.weightKg,
          targetWeightKg: target,
          goal: details?.goal,
        ),
        monthlyChangeKg: progress.weightChangeThisMonth,
        entries: progress.weightEntries,
      ),
    );
  }

  bool _hasReachedWeightGoal({
    required double? currentWeightKg,
    required double? targetWeightKg,
    required WellnessGoal? goal,
  }) {
    if (currentWeightKg == null || targetWeightKg == null) return false;
    return switch (goal) {
      WellnessGoal.loseWeight => currentWeightKg <= targetWeightKg,
      WellnessGoal.maintainWeight =>
        (currentWeightKg - targetWeightKg).abs() <= 0.1,
      WellnessGoal.gainWeight => currentWeightKg >= targetWeightKg,
      _ => false,
    };
  }
}
