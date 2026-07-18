import 'package:calora/core/formatters/measurement_formatter.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:flutter/material.dart';

class ProfileDetailsSummary extends StatelessWidget {
  const ProfileDetailsSummary({super.key, required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final details = profile?.onboarding;
    return CaloraGroupedList(
      children: <Widget>[
        CaloraListRow(
          icon: Icons.person_outline,
          title: 'Name',
          subtitle: profile?.name ?? '',
        ),
        CaloraListRow(
          icon: Icons.person_outline,
          title: 'Age',
          subtitle: '${details?.age ?? 0}',
        ),
        CaloraListRow(
          icon: Icons.height,
          title: 'Height',
          subtitle: MeasurementFormatter.height(
            details?.heightCm,
            details?.unitSystem,
          ),
        ),
        CaloraListRow(
          icon: Icons.circle_outlined,
          title: 'Current weight',
          subtitle: MeasurementFormatter.weight(
            details?.currentWeightKg,
            details?.unitSystem,
          ),
        ),
      ],
    );
  }
}
