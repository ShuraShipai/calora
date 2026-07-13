import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_card.dart';
import 'package:calora/features/home/models/home_dashboard.dart';
import 'package:flutter/material.dart';

class HomeWaterCard extends StatelessWidget {
  const HomeWaterCard({super.key, required this.dashboard});

  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return CaloraCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: AppRadii.cardBorder,
        onTap: () => unawaited(Navigator.pushNamed(context, AppRoutes.water)),
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
                  Icons.water_drop_outlined,
                  color: context.colors.water,
                  size: AppSizes.icon,
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Water intake',
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                    Text(
                      '${dashboard.waterMillilitres} ml',
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
