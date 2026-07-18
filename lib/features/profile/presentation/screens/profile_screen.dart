import 'package:calora/app/router/app_routes.dart';
import 'package:calora/app/widgets/main_bottom_navigation.dart';
import 'package:calora/core/models/daily_goal_status.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/profile/presentation/widgets/account_reauthentication_sheet.dart';
import 'package:calora/features/profile/presentation/widgets/profile_account_actions.dart';
import 'package:calora/features/profile/presentation/widgets/profile_confirm_action_sheet.dart';
import 'package:calora/features/profile/presentation/widgets/profile_identity_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:calora/features/profile/presentation/widgets/profile_theme_row.dart';
import 'package:calora/features/profile/providers/data_export_provider.dart';
import 'package:calora/features/progress/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final dataExport = context.watch<DataExportProvider>();
    final profile = auth.profile;
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
            ProfileSection(
              title: 'Data & support',
              child: CaloraGroupedList(
                children: <Widget>[
                  CaloraListRow(
                    icon: Icons.file_download_outlined,
                    title: 'Export my data',
                    onTap: dataExport.isExporting
                        ? null
                        : () => _exportData(context),
                  ),
                  CaloraListRow(
                    icon: Icons.lock_outline,
                    title: 'Privacy',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.privacy),
                  ),
                  CaloraListRow(
                    icon: Icons.help_outline,
                    title: 'Help & support',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.helpSupport),
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
                onDeleteAccount: auth.isBusy
                    ? null
                    : () => _showConfirmation(
                        context,
                        title: 'Delete account?',
                        description:
                            'This permanently removes your diary, progress history and profile. This can\'t be undone.',
                        confirmLabel: 'Delete',
                        onConfirm: () async {
                          final password = await showCaloraSheet<String>(
                            context: context,
                            showDragHandle: false,
                            cardStyle: true,
                            builder: (_) =>
                                const AccountReauthenticationSheet(),
                          );
                          if (password == null || !context.mounted) return;
                          final deleted = await context
                              .read<AuthProvider>()
                              .deleteAccount(password: password);
                          if (!context.mounted) return;
                          if (!deleted) {
                            final error = context
                                .read<AuthProvider>()
                                .errorMessage;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  error ?? 'Could not delete account.',
                                ),
                              ),
                            );
                            return;
                          }
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.splash,
                            (route) => false,
                          );
                        },
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

  Future<void> _exportData(BuildContext context) async {
    final diary = context.read<DiaryProvider>();
    final progress = context.read<ProgressProvider>();
    final onboarding = context.read<AuthProvider>().profile?.onboarding;
    final nutrition = diary.nutritionToday;
    final exported = await context.read<DataExportProvider>().export(
      diaryEntries: diary.entries,
      waterEntries: progress.waterEntries,
      weightEntries: progress.weightEntries,
      dailyGoals: dailyGoalStatuses(
        caloriesEaten: nutrition.calories,
        calorieGoal: onboarding?.dailyCalorieTarget ?? 0,
        proteinGrams: nutrition.protein,
        proteinGoalGrams: onboarding?.proteinGoalGrams ?? 0,
        carbohydratesGrams: nutrition.carbs,
        carbohydratesGoalGrams: onboarding?.carbohydrateGoalGrams ?? 0,
        fatGrams: nutrition.fat,
        fatGoalGrams: onboarding?.fatGoalGrams ?? 0,
        waterMillilitres: progress.waterTodayMl,
        waterGoalLiters: onboarding?.waterGoalLiters,
        currentWeightKg: progress.latestWeight?.weightKg,
        targetWeightKg: onboarding?.targetWeightKg,
        wellnessGoal: onboarding?.goal,
      ),
    );
    if (!context.mounted || exported) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.read<DataExportProvider>().errorMessage ??
              'Could not export your data.',
        ),
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
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ProfileConfirmActionDialog(
        title: title,
        description: description,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
      ),
    );
  }
}
