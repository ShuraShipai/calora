import 'package:calora/app/providers/theme_provider.dart';
import 'package:calora/core/widgets/calora_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileThemeRow extends StatelessWidget {
  const ProfileThemeRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CaloraListRow(
      icon: Icons.light_mode_outlined,
      title: 'Theme',
      subtitle: isDark ? 'Dark' : 'Light',
      trailing: Switch.adaptive(
        value: isDark,
        onChanged: (_) => context.read<ThemeProvider>().toggle(
          MediaQuery.platformBrightnessOf(context),
        ),
      ),
    );
  }
}
