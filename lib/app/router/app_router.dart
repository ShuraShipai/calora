import 'package:calora/app/router/app_routes.dart';
import 'package:calora/features/auth/presentation/screens/login_screen.dart';
import 'package:calora/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:calora/features/diary/presentation/screens/diary_screen.dart';
import 'package:calora/features/food/presentation/screens/add_food_screen.dart';
import 'package:calora/features/food/presentation/screens/copy_meal_screen.dart';
import 'package:calora/features/food/presentation/screens/custom_food_screen.dart';
import 'package:calora/features/home/presentation/screens/home_screen.dart';
import 'package:calora/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:calora/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:calora/features/profile/presentation/screens/goals_screen.dart';
import 'package:calora/features/profile/presentation/screens/personal_details_screen.dart';
import 'package:calora/features/profile/presentation/screens/profile_screen.dart';
import 'package:calora/features/profile/presentation/screens/reminders_screen.dart';
import 'package:calora/features/profile/presentation/screens/units_screen.dart';
import 'package:calora/features/progress/presentation/screens/progress_screen.dart';
import 'package:calora/features/progress/presentation/screens/water_screen.dart';
import 'package:calora/features/progress/presentation/screens/weight_screen.dart';
import 'package:calora/features/scanner/presentation/screens/scan_results_screen.dart';
import 'package:calora/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:flutter/material.dart';

abstract final class AppRouter {
  static Route<void> onGenerateRoute(RouteSettings settings) {
    final builder = _routes[settings.name];
    if (builder == null) return onUnknownRoute(settings);
    return MaterialPageRoute<void>(builder: builder, settings: settings);
  }

  static Route<void> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => const SplashScreen(),
      settings: const RouteSettings(name: AppRoutes.splash),
    );
  }

  static final Map<String, WidgetBuilder> _routes = <String, WidgetBuilder>{
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.signUp: (_) => const SignUpScreen(),
    AppRoutes.onboarding: (_) => const OnboardingScreen(),
    AppRoutes.home: (_) => const HomeScreen(),
    AppRoutes.diary: (_) => const DiaryScreen(),
    AppRoutes.addFood: (_) => const AddFoodScreen(),
    AppRoutes.copyMeal: (_) => const CopyMealScreen(),
    AppRoutes.customFood: (_) => const CustomFoodScreen(),
    AppRoutes.scanner: (_) => const ScannerScreen(),
    AppRoutes.scanResults: (_) => const ScanResultsScreen(),
    AppRoutes.water: (_) => const WaterScreen(),
    AppRoutes.weight: (_) => const WeightScreen(),
    AppRoutes.progress: (_) => const ProgressScreen(),
    AppRoutes.goals: (_) => const GoalsScreen(),
    AppRoutes.profile: (_) => const ProfileScreen(),
    AppRoutes.reminders: (_) => const RemindersScreen(),
    AppRoutes.units: (_) => const UnitsScreen(),
    AppRoutes.personalDetails: (_) => const PersonalDetailsScreen(),
  };
}
