import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/profile/presentation/widgets/goal_edit_sheet.dart';
import 'package:calora/features/profile/presentation/widgets/goals_list.dart';
import 'package:calora/features/profile/presentation/widgets/profile_page_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
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
                    _showEditor(context, title, '$value $unit'),
              ),
            ),
            const SizedBox(height: AppSpacing.section),
          ],
        ),
      ),
    );
  }

  void _showEditor(BuildContext context, String title, String value) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => GoalEditSheet(title: title, value: value),
    );
  }
}
