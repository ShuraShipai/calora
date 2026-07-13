import 'package:calora/app/router/app_routes.dart';
import 'package:calora/app/widgets/main_bottom_navigation.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/profile/presentation/widgets/profile_account_actions.dart';
import 'package:calora/features/profile/presentation/widgets/profile_confirm_action_sheet.dart';
import 'package:calora/features/profile/presentation/widgets/profile_identity_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:calora/features/profile/presentation/widgets/profile_theme_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthProvider>().profile;
    return Scaffold(
      key: const ValueKey<String>('profile'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          children: <Widget>[
            ProfileSection(
              top: AppSpacing.sm,
              child: ProfileIdentityHeader(profile: profile),
            ),
            ProfileSection(
              title: 'Account',
              child: CaloraGroupedList(
                children: <Widget>[
                  CaloraListRow(
                    icon: Icons.person_outline,
                    title: 'Personal details',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.personalDetails),
                  ),
                  CaloraListRow(
                    icon: Icons.near_me_outlined,
                    title: 'Health goals',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.goals),
                  ),
                  CaloraListRow(
                    icon: Icons.format_align_justify,
                    title: 'Units',
                    subtitle:
                        profile?.onboarding?.unitSystem == UnitSystem.imperial
                        ? 'Imperial'
                        : 'Metric',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.units),
                  ),
                ],
              ),
            ),
            ProfileSection(
              title: 'Preferences',
              child: CaloraGroupedList(
                children: <Widget>[
                  CaloraListRow(
                    icon: Icons.notifications_none,
                    title: 'Reminders & notifications',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.reminders),
                  ),
                  const ProfileThemeRow(),
                ],
              ),
            ),
            const ProfileSection(
              title: 'Data & support',
              child: CaloraGroupedList(
                children: <Widget>[
                  CaloraListRow(
                    icon: Icons.file_download_outlined,
                    title: 'Export my data',
                  ),
                  CaloraListRow(icon: Icons.lock_outline, title: 'Privacy'),
                  CaloraListRow(
                    icon: Icons.help_outline,
                    title: 'Help & support',
                  ),
                ],
              ),
            ),
            ProfileSection(
              child: ProfileAccountActions(
                onLogOut: () => _showConfirmation(
                  context,
                  title: 'Log out?',
                  description: 'You can sign back in anytime with your email.',
                  confirmLabel: 'Log out',
                  onConfirm: () async {
                    await context.read<AuthProvider>().signOut();
                    if (!context.mounted) return;
                    await Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.splash,
                      (route) => false,
                    );
                  },
                ),
                onDeleteAccount: () => _showConfirmation(
                  context,
                  title: 'Delete account?',
                  description:
                      'This permanently removes your diary, progress history and profile. This can\'t be undone.',
                  confirmLabel: 'Delete',
                  onConfirm: () => Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.splash, (route) => false),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(
        selectedTab: MainTab.profile,
      ),
    );
  }

  void _showConfirmation(
    BuildContext context, {
    required String title,
    required String description,
    required String confirmLabel,
    required VoidCallback onConfirm,
  }) {
    showCaloraSheet<void>(
      context: context,
      builder: (sheetContext) => ProfileConfirmActionSheet(
        title: title,
        description: description,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
      ),
    );
  }
}
