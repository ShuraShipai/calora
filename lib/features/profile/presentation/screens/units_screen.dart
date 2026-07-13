import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:calora/features/profile/presentation/widgets/profile_page_header.dart';
import 'package:calora/features/profile/presentation/widgets/profile_section.dart';
import 'package:calora/features/profile/presentation/widgets/units_choice_cards.dart';
import 'package:flutter/material.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({super.key});
  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  bool _metric = true;
  @override
  Widget build(BuildContext context) => Scaffold(
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
                  metric: _metric,
                  onChanged: (value) => setState(() => _metric = value),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                CaloraGroupedList(
                  children: <Widget>[
                    CaloraListRow(
                      icon: Icons.circle_outlined,
                      title: 'Weight',
                      subtitle: _metric ? 'Kilograms' : 'Pounds',
                    ),
                    CaloraListRow(
                      icon: Icons.height,
                      title: 'Height',
                      subtitle: _metric ? 'Centimeters' : 'Feet and inches',
                    ),
                    CaloraListRow(
                      icon: Icons.water_drop_outlined,
                      title: 'Water',
                      subtitle: _metric
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
              onPressed: () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Units saved'))),
            ),
          ),
        ],
      ),
    ),
  );
}
