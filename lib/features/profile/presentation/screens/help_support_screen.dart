import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/profile/presentation/widgets/help_support_content.dart';
import 'package:calora/features/profile/presentation/widgets/profile_page_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('help-support'),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const ProfilePageHeader(title: 'Help & support'),
            ProfileSection(
              title: 'Frequently asked questions',
              child: HelpSupportContent(
                onContactSupport: () => _showContactSupportMessage(context),
              ),
            ),
            const SizedBox(height: AppSpacing.section),
          ],
        ),
      ),
    );
  }

  void _showContactSupportMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact support is coming soon')),
    );
  }
}
