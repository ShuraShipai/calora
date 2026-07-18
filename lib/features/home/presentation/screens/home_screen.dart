import 'package:calora/app/widgets/main_bottom_navigation.dart';
import 'package:calora/core/models/daily_goal_status.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/diary/models/meal_type.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/home/models/home_dashboard.dart';
import 'package:calora/features/home/presentation/widgets/home_calorie_summary.dart';
import 'package:calora/features/home/presentation/widgets/home_header.dart';
import 'package:calora/features/home/presentation/widgets/home_macros.dart';
import 'package:calora/features/home/presentation/widgets/home_meals_section.dart';
import 'package:calora/features/home/presentation/widgets/home_water_card.dart';
import 'package:calora/features/home/presentation/widgets/home_weight_card.dart';
import 'package:calora/features/progress/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diary = context.watch<DiaryProvider>();
    final progress = context.watch<ProgressProvider>();
    final profile = context.watch<AuthProvider>().profile;
    final dashboard = _dashboardFor(
      diary: diary,
      calorieGoal: profile?.onboarding?.dailyCalorieTarget ?? 0,
      proteinGoal: profile?.onboarding?.proteinGoalGrams ?? 0,
      carbohydrateGoal: profile?.onboarding?.carbohydrateGoalGrams ?? 0,
      fatGoal: profile?.onboarding?.fatGoalGrams ?? 0,
    );
    final dailyGoals = dailyGoalStatuses(
      caloriesEaten: dashboard.caloriesEaten,
      calorieGoal: dashboard.calorieGoal,
      proteinGrams: dashboard.proteinGrams,
      proteinGoalGrams: dashboard.proteinGoalGrams,
      carbohydratesGrams: dashboard.carbohydratesGrams,
      carbohydratesGoalGrams: dashboard.carbohydratesGoalGrams,
      fatGrams: dashboard.fatGrams,
      fatGoalGrams: dashboard.fatGoalGrams,
      waterMillilitres: progress.waterTodayMl,
      waterGoalLiters: profile?.onboarding?.waterGoalLiters,
      currentWeightKg: progress.latestWeight?.weightKg,
      targetWeightKg: profile?.onboarding?.targetWeightKg,
      wellnessGoal: profile?.onboarding?.goal,
    );
    return CaloraPage(
      screenId: 'home',
      bottomNavigationBar: const MainBottomNavigation(
        selectedTab: MainTab.home,
      ),
      child: ListView(
        padding: EdgeInsets.only(top: AppSpacing.sm.h),
        children: <Widget>[
          CaloraSection(
            bottom: AppSpacing.xxl,
            child: HomeHeader(name: profile?.name ?? ''),
          ),
          CaloraSection(
            child: HomeCalorieSummary(
              dashboard: dashboard,
              dailyGoals: dailyGoals,
            ),
          ),
          CaloraSection(child: HomeMacros(dashboard: dashboard)),
          CaloraSection(
            child: HomeWaterCard(
              dashboard: dashboard,
              waterMillilitres: progress.waterTodayMl,
              unitSystem: profile?.onboarding?.unitSystem,
            ),
          ),
          CaloraSection(
            child: HomeWeightCard(
              currentWeightKg:
                  progress.latestWeight?.weightKg ??
                  profile?.onboarding?.currentWeightKg,
              targetWeightKg: profile?.onboarding?.targetWeightKg,
              unitSystem: profile?.onboarding?.unitSystem,
            ),
          ),
          HomeMealsSection(diary: diary),
          SizedBox(height: AppSpacing.xxl.h),
        ],
      ),
    );
  }

  HomeDashboard _dashboardFor({
    required DiaryProvider diary,
    required int calorieGoal,
    required int proteinGoal,
    required int carbohydrateGoal,
    required int fatGoal,
  }) {
    final nutrition = diary.nutritionToday;
    final today = DateTime.now();
    return HomeDashboard(
      calorieGoal: calorieGoal,
      caloriesEaten: nutrition.calories,
      proteinGrams: nutrition.protein,
      proteinGoalGrams: proteinGoal,
      carbohydratesGrams: nutrition.carbs,
      carbohydratesGoalGrams: carbohydrateGoal,
      fatGrams: nutrition.fat,
      fatGoalGrams: fatGoal,
      waterMillilitres: 0,
      meals: Map<HomeMealType, HomeMealSummary>.unmodifiable(
        <HomeMealType, HomeMealSummary>{
          for (final type in HomeMealType.values)
            type: HomeMealSummary(
              itemCount: diary.entriesFor(today, _mealTypeFor(type)).length,
              calories: diary.caloriesFor(today, _mealTypeFor(type)),
            ),
        },
      ),
    );
  }

  MealType _mealTypeFor(HomeMealType type) => switch (type) {
    HomeMealType.breakfast => MealType.breakfast,
    HomeMealType.lunch => MealType.lunch,
    HomeMealType.dinner => MealType.dinner,
    HomeMealType.snacks => MealType.snacks,
  };
}
