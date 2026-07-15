import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_view.dart';
import 'package:calora/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingProvider>(
      create: (context) => OnboardingProvider(
        initialName: context.read<AuthProvider>().profile?.name ?? '',
      ),
      child: const OnboardingView(),
    );
  }
}
