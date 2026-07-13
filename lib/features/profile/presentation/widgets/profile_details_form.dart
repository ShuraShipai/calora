import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_form.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:flutter/material.dart';

class ProfileDetailsForm extends StatelessWidget {
  const ProfileDetailsForm({super.key, required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final details = profile?.onboarding;
    return Column(
      children: <Widget>[
        CaloraLabeledField(label: 'Name', initialValue: profile?.name ?? ''),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: <Widget>[
            Expanded(
              child: CaloraLabeledField(
                label: 'Age',
                initialValue: '${details?.age ?? 0}',
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: CaloraLabeledField(
                label: 'Height',
                initialValue: '${details?.heightCm ?? 0} cm',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: <Widget>[
            Expanded(
              child: CaloraLabeledField(
                label: 'Current weight',
                initialValue: '${details?.currentWeightKg ?? 0} kg',
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: CaloraLabeledField(
                label: 'Target weight',
                initialValue: '${details?.targetWeightKg ?? 0} kg',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
