import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/formatters/measurement_formatter.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:flutter/material.dart';

class HomeWeightCard extends StatelessWidget {
  const HomeWeightCard({
    super.key,
    required this.currentWeightKg,
    required this.targetWeightKg,
    required this.unitSystem,
  });

  final double? currentWeightKg;
  final double? targetWeightKg;
  final UnitSystem? unitSystem;

  @override
  Widget build(BuildContext context) {
    final current = currentWeightKg == null
        ? 'No weight logged'
        : MeasurementFormatter.weight(currentWeightKg, unitSystem);
    final target = targetWeightKg == null
        ? 'No target set'
        : 'Target ${MeasurementFormatter.weight(targetWeightKg, unitSystem)}';

    return CaloraCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: AppRadii.cardBorder,
        onTap: () => unawaited(Navigator.pushNamed(context, AppRoutes.weight)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.section),
          child: Row(
            children: <Widget>[
              Container(
                width: AppSizes.onboardingIcon,
                height: AppSizes.onboardingIcon,
                decoration: BoxDecoration(
                  color: context.colors.mossTint,
                  borderRadius: BorderRadius.circular(AppRadii.thumbnail),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.monitor_weight_outlined,
                  color: context.colors.moss,
                  size: AppSizes.icon,
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Weight',
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                    Text(
                      '$current · $target',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.colors.inkFaint,
                size: AppFontSizes.sheetTitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
