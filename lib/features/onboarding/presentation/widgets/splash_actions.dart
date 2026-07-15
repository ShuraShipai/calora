import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_action_button.dart';
import 'package:flutter/material.dart';

class SplashActions extends StatelessWidget {
  const SplashActions({
    super.key,
    required this.onLogin,
    required this.onSignUp,
  });

  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CaloraActionButton(label: 'Log In', onPressed: onLogin),
        const SizedBox(height: AppSpacing.lg),
        CaloraActionButton(
          label: 'Create Account',
          style: CaloraActionButtonStyle.secondary,
          onPressed: onSignUp,
        ),
      ],
    );
  }
}
