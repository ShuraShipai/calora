import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_activity_step.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_details_step.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_footer.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_goal_step.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_progress.dart';
import 'package:calora/features/onboarding/presentation/widgets/onboarding_units_step.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _totalSteps = 4;
  int _step = 0;

  void _finish() {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
  }

  void _next() {
    if (_step == _totalSteps - 1) {
      _finish();
      return;
    }
    setState(() => _step++);
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  Widget _currentStep() {
    return switch (_step) {
      0 => const OnboardingDetailsStep(),
      1 => const OnboardingActivityStep(),
      2 => const OnboardingGoalStep(),
      _ => const OnboardingUnitsStep(),
    };
  }

  @override
  Widget build(BuildContext context) {
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
                OnboardingProgress(currentStep: _step, totalSteps: _totalSteps),
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
                        key: ValueKey<int>(_step),
                        child: _currentStep(),
                      ),
                    ),
                  ),
                ),
                OnboardingFooter(
                  showBack: _step > 0,
                  isLastStep: _step == _totalSteps - 1,
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
