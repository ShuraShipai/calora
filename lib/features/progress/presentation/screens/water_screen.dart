import 'package:calora/core/formatters/measurement_formatter.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/progress/presentation/widgets/custom_water_sheet.dart';
import 'package:calora/features/progress/presentation/widgets/water_page_body.dart';
import 'package:calora/features/progress/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  void _showAddedMessage(int amount) {
    showCaloraMessage(context, '+$amount ml logged');
  }

  Future<void> _addWater(int amount) async {
    try {
      await context.read<ProgressProvider>().addWater(amount);
      if (mounted) _showAddedMessage(amount);
    } catch (_) {
      if (!mounted) return;
      showCaloraMessage(context, 'Could not save water entry.');
    }
  }

  Future<void> _showCustomWaterSheet() async {
    final unitSystem = context
        .read<AuthProvider>()
        .profile
        ?.onboarding
        ?.unitSystem;
    final amount = await showCaloraSheet<int>(
      context: context,
      showDragHandle: false,
      builder: (_) => CustomWaterSheet(unitSystem: unitSystem),
    );
    if (!mounted || amount == null) return;
    await _addWater(amount);
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final details = context.watch<AuthProvider>().profile?.onboarding;
    final unitSystem = details?.unitSystem;
    final goalMl = _waterGoalMl(details);
    final total = progress.waterTodayMl;
    return CaloraScreenScaffold(
      screenId: 'water',
      title: 'Water',
      showBackButton: true,
      body: WaterPageBody(
        amountLabel: MeasurementFormatter.water(total, unitSystem),
        goalLabel: goalMl == null
            ? 'No water goal set'
            : 'of ${MeasurementFormatter.water(goalMl, unitSystem)}',
        progress: goalMl == null ? 0 : total / goalMl,
        entries: progress.waterEntriesToday,
        onAdd250: () => _addWater(250),
        onAdd500: () => _addWater(500),
        onCustom: _showCustomWaterSheet,
      ),
    );
  }

  int? _waterGoalMl(OnboardingDetails? details) {
    final liters = details?.waterGoalLiters;
    return liters == null || liters <= 0 ? null : (liters * 1000).round();
  }
}
