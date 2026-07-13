import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/features/profile/presentation/widgets/profile_details_form.dart';
import 'package:calora/features/profile/presentation/widgets/profile_details_summary.dart';
import 'package:calora/features/profile/presentation/widgets/profile_page_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthProvider>().profile;
    return Scaffold(
      key: const ValueKey<String>('personaldetails'),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const ProfilePageHeader(title: 'Personal details'),
            ProfileSection(child: ProfileDetailsSummary(profile: profile)),
            ProfileSection(
              title: 'Profile',
              child: ProfileDetailsForm(profile: profile),
            ),
            ProfileSection(
              child: CaloraActionButton(
                label: 'Save details',
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Personal details saved')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
