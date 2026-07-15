import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/features/profile/presentation/widgets/profile_page_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('privacy'),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const ProfilePageHeader(title: 'Privacy'),
            ProfileSection(
              child: Text(
                'Understand the information Calora uses to support your health tracking.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.inkSoft,
                ),
              ),
            ),
            const ProfileSection(
              title: 'Your data',
              child: CaloraGroupedList(
                children: <Widget>[
                  CaloraListRow(
                    icon: Icons.person_outline,
                    title: 'Profile & goals',
                    subtitle:
                        'Your details, measurements and nutrition targets.',
                  ),
                  CaloraListRow(
                    icon: Icons.restaurant_outlined,
                    title: 'Diary & food scans',
                    subtitle: 'Food entries, serving details and scan results.',
                  ),
                  CaloraListRow(
                    icon: Icons.insights_outlined,
                    title: 'Progress & water',
                    subtitle: 'Weight, hydration and progress history.',
                  ),
                ],
              ),
            ),
            ProfileSection(
              title: 'How your data is used',
              child: Text(
                'Calora uses this information to show your diary, support your goals and track your progress.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.inkSoft,
                ),
              ),
            ),
            const ProfileSection(
              title: 'Your controls',
              child: CaloraGroupedList(
                children: <Widget>[
                  CaloraListRow(
                    icon: Icons.file_download_outlined,
                    title: 'Export your data',
                    subtitle: 'Request a copy of your Calora information.',
                  ),
                  CaloraListRow(
                    icon: Icons.delete_outline,
                    title: 'Delete your account',
                    subtitle:
                        'Permanently remove your Calora account and data.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.section),
          ],
        ),
      ),
    );
  }
}
