import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_brand_mark.dart';
import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CaloraScreenScaffold(
      screenId: 'splash',
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CaloraBrandMark(),
            const SizedBox(height: AppSpacing.section),
            Text('Calora', style: Theme.of(context).textTheme.displayLarge),
          ],
        ),
      ),
    );
  }
}
