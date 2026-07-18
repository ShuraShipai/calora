import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:calora/features/auth/presentation/widgets/forgot_password_form.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return AuthScaffold(
      screenId: 'forgot-password',
      horizontalPadding: AppSpacing.x3,
      titleSize: AppFontSizes.titleLarge,
      subtitleSize: AppFontSizes.body,
      title: 'Reset password',
      subtitle: 'Enter your email and Calora will send reset instructions.',
      contentSpacing: AppSpacing.x3,
      child: ForgotPasswordForm(
        isLoading: auth.isBusy,
        errorMessage: auth.errorMessage,
        onSendResetLink: (email) async {
          final success = await context
              .read<AuthProvider>()
              .sendPasswordResetEmail(email);
          if (!context.mounted || !success) return;
          showCaloraMessage(context, 'Password reset email sent.');
        },
        onBackToLogin: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.login),
      ),
    );
  }
}
