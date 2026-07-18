import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/profile/presentation/widgets/profile_details_form.dart';
import 'package:calora/features/profile/presentation/widgets/profile_details_summary.dart';
import 'package:calora/features/profile/presentation/widgets/profile_page_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<ProfileDetailsFormState>();

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
              child: ProfileDetailsForm(key: _formKey, profile: profile),
            ),
            ProfileSection(
              child: CaloraActionButton(
                label: 'Save details',
                onPressed: _saveDetails,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDetails() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid profile details.')),
      );
      return;
    }
    final saved = await context.read<AuthProvider>().updateProfile(
      name: form.name,
      details: form.details,
    );
    if (!mounted || !saved) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Personal details saved')));
  }
}
