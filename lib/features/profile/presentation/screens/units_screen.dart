import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/profile/presentation/widgets/profile_page_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:calora/features/profile/presentation/widgets/units_choice_cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({super.key});
  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  bool? _metric;
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final metric =
        _metric ?? auth.profile?.onboarding?.unitSystem != UnitSystem.imperial;
    return Scaffold(
      key: const ValueKey<String>('units'),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const ProfilePageHeader(title: 'Units'),
            ProfileSection(
              child: Text(
                'Choose how measurements appear across your diary, goals and progress.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.inkSoft,
                ),
              ),
            ),
            ProfileSection(
              title: 'Measurement system',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UnitsChoiceCards(
                    metric: metric,
                    onChanged: (value) => setState(() => _metric = value),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  CaloraGroupedList(
                    children: <Widget>[
                      CaloraListRow(
                        icon: Icons.circle_outlined,
                        title: 'Weight',
                        subtitle: metric ? 'Kilograms' : 'Pounds',
                      ),
                      CaloraListRow(
                        icon: Icons.height,
                        title: 'Height',
                        subtitle: metric ? 'Centimeters' : 'Feet and inches',
                      ),
                      CaloraListRow(
                        icon: Icons.water_drop_outlined,
                        title: 'Water',
                        subtitle: metric
                            ? 'Milliliters and liters'
                            : 'Fluid ounces',
                      ),
                      const CaloraListRow(
                        icon: Icons.breakfast_dining_outlined,
                        title: 'Energy',
                        subtitle: 'Calories',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ProfileSection(
              child: CaloraActionButton(
                label: 'Save units',
                onPressed: () => _saveUnits(auth, metric),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveUnits(AuthProvider auth, bool metric) async {
    final details = auth.profile?.onboarding ?? const OnboardingDetails();
    final saved = await auth.updateProfile(
      name: auth.profile?.name ?? '',
      details: details.copyWith(
        unitSystem: metric ? UnitSystem.metric : UnitSystem.imperial,
      ),
    );
    if (!mounted || !saved) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Units saved')));
  }
}
