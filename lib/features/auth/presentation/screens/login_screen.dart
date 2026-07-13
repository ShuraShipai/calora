import 'package:calora/app/router/app_routes.dart';
import 'package:calora/features/auth/presentation/widgets/auth_footer.dart';
import 'package:calora/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:calora/features/auth/presentation/widgets/login_form.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return AuthScaffold(
      screenId: 'login',
      title: 'Welcome back',
      subtitle: 'Log in to continue tracking your meals and progress.',
      footer: AuthFooter(
        prompt: 'New to Calora?',
        action: 'Create account',
        onPressed: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.signUp),
      ),
      child: LoginForm(
        isLoading: auth.isBusy,
        errorMessage: auth.errorMessage,
        onLogIn: (email, password) async {
          final success = await context.read<AuthProvider>().signIn(
            email: email,
            password: password,
          );
          if (!context.mounted || !success) return;
          final destination =
              context.read<AuthProvider>().profile?.onboardingComplete == true
              ? AppRoutes.home
              : AppRoutes.onboarding;
          await Navigator.pushNamedAndRemoveUntil(
            context,
            destination,
            (_) => false,
          );
        },
        onForgotPassword: () =>
            Navigator.pushNamed(context, AppRoutes.forgotPassword),
      ),
    );
  }
}
