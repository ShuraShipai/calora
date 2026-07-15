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
    final entry = await showCaloraSheet<WeightEntryDraft>(
      context: context,
      builder: (_) => const LogWeightSheet(),
    );
    if (!context.mounted || entry == null) return;
    try {
      await context.read<ProgressProvider>().addWeight(
        weightKg: entry.weightKg,
        loggedAt: entry.loggedAt,
        note: entry.note,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Weight logged')));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save weight entry.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final target = context
        .watch<AuthProvider>()
        .profile
        ?.onboarding
        ?.targetWeightKg;
    return CaloraScreenScaffold(
      screenId: 'weight',
      title: 'Weight',
      showBackButton: true,
      body: WeightPageBody(
        onLogWeight: () => _showLogWeightSheet(context),
        currentWeightKg: progress.latestWeight?.weightKg,
        targetWeightKg: target,
        monthlyChangeKg: progress.weightChangeThisMonth,
        trendValues: progress.weightTrend,
        entries: progress.weightEntries,
      ),
    );
  }
}
