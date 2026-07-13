import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';

class ProfileIdentityHeader extends StatelessWidget {
  const ProfileIdentityHeader({super.key, required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: AppSizes.profileAvatar,
          height: AppSizes.profileAvatar,
          decoration: BoxDecoration(
            color: context.colors.mossTint,
            borderRadius: AppRadii.pillBorder,
          ),
          child: Icon(
            Icons.person_outline,
            size: AppFontSizes.display,
            color: context.colors.moss,
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                profile?.name ?? '',
                style: context.textTheme.titleMedium?.copyWith(
                  fontSize: AppFontSizes.compactTitle,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Goal: ${profile?.onboarding?.dailyCalorieTarget ?? 0} kcal/day',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.inkSoft,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
