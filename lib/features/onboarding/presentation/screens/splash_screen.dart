import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/onboarding/presentation/widgets/splash_actions.dart';
import 'package:calora/features/onboarding/presentation/widgets/splash_brand_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasRouted = false;

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthProvider>().status;
    final destination = switch (status) {
      AuthStatus.authenticated => AppRoutes.home,
      AuthStatus.requiresOnboarding => AppRoutes.onboarding,
      _ => null,
    };
    if (destination != null && !_hasRouted) {
      _hasRouted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, destination, (_) => false);
      });
    }
    final showActions = status == AuthStatus.unauthenticated;
    return Scaffold(
      key: const ValueKey<String>('splash'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.authContentMaxWidth,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                const Center(child: SplashBrandContent()),
                if (showActions)
                  Positioned(
                    left: AppSpacing.page,
                    right: AppSpacing.page,
                    bottom: AppSpacing.x6,
                    child: SplashActions(
                      onLogin: () =>
                          Navigator.pushNamed(context, AppRoutes.login),
                      onSignUp: () =>
                          Navigator.pushNamed(context, AppRoutes.signUp),
                      onGuest: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.onboarding,
                        (_) => false,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
