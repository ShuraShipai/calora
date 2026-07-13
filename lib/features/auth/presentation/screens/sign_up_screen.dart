import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/auth/presentation/widgets/auth_footer.dart';
import 'package:calora/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:calora/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return AuthScaffold(
      screenId: 'sign-up',
      horizontalPadding: AppSpacing.x3,
      titleSize: AppFontSizes.titleLarge,
      subtitleSize: AppFontSizes.body,
      contentSpacing: AppSpacing.x3,
      footerSpacing: AppSpacing.section,
      title: 'Create your account',
      subtitle:
          'Start with a simple profile so Calora can personalize your plan.',
      footer: AuthFooter(
        prompt: 'Already have an account?',
        action: 'Log in',
        onPressed: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.login),
      ),
      child: SignUpForm(
        isLoading: auth.isBusy,
        errorMessage: auth.errorMessage,
        onCreateAccount: (name, email, password) async {
          final success = await context.read<AuthProvider>().signUp(
            name: name,
            email: email,
            password: password,
          );
          if (!context.mounted || !success) return;
          await Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.onboarding,
            (_) => false,
          );
        },
      ),
    );
  }
}
