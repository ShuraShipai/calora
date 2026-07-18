import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_activity_step.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_details_step.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_footer.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_goal_step.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_progress.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_units_step.dart';
import 'package:calora/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _detailsFormKey = GlobalKey<FormState>();
  bool _isCompleting = false;

  Future<void> _finish() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);
    final onboarding = context.read<OnboardingProvider>();
    final auth = context.read<AuthProvider>();
    final completed = await auth.completeOnboarding(
      name: onboarding.name.trim(),
      details: onboarding.details,
    );
    if (!mounted) return;
    setState(() => _isCompleting = false);
    if (completed) {
      unawaited(
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (_) => false,
        ),
      );
    } else if (auth.errorMessage != null) {
      showCaloraMessage(context, auth.errorMessage!);
    }
  }

  void _next() {
    final onboarding = context.read<OnboardingProvider>();
    if (onboarding.isFirstStep &&
        !(_detailsFormKey.currentState?.validate() ?? false)) {
      return;
    }
    final selectionMissing =
        (onboarding.step == 1 && onboarding.activityLevel == null) ||
        (onboarding.step == 2 && onboarding.goal == null) ||
        (onboarding.isLastStep && onboarding.unitSystem == null);
    if (selectionMissing) {
      showCaloraMessage(context, 'Choose an option to continue.');
      return;
    }
    if (onboarding.isLastStep) {
      unawaited(_finish());
      return;
    }
    onboarding.next();
  }

  void _back() => context.read<OnboardingProvider>().back();

  Widget _currentStep(int step) => switch (step) {
    0 => Form(key: _detailsFormKey, child: const OnboardingDetailsStep()),
    1 => const OnboardingActivityStep(),
    2 => const OnboardingGoalStep(),
    _ => const OnboardingUnitsStep(),
  };

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return Scaffold(
      key: const ValueKey<String>('ob-1'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.authContentMaxWidth,
            ),
            child: Column(
              children: <Widget>[
                OnboardingHeader(onSkip: _finish),
                OnboardingProgress(
                  currentStep: onboarding.step,
                  totalSteps: OnboardingProvider.totalSteps,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      AppSpacing.sectionGap,
                      AppSpacing.page,
                      AppSpacing.page,
                    ),
                    child: AnimatedSwitcher(
                      duration: AppDurations.fast,
                      child: KeyedSubtree(
                        key: ValueKey<int>(onboarding.step),
                        child: _currentStep(onboarding.step),
                      ),
                    ),
                  ),
                ),
                OnboardingFooter(
                  showBack: !onboarding.isFirstStep,
                  isLastStep: onboarding.isLastStep,
                  onBack: _back,
                  onNext: _next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
