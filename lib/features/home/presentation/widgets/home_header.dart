import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final greeting = name.trim().isEmpty
        ? 'Calories in check'
        : 'Calories in check, $name';
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                greeting,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: AppFontSizes.sectionTitle,
                ),
              ),
              Text(
                MaterialLocalizations.of(
                  context,
                ).formatFullDate(DateTime.now()),
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colors.inkSoft,
                ),
              ),
            ],
          ),
        ),
        CaloraIconButton(
          tooltip: 'Profile',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          icon: Icons.person_outline,
        ),
      ],
    );
  }
}
