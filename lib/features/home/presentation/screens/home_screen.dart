import 'package:calora/app/widgets/main_bottom_navigation.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/home/presentation/widgets/home_calorie_summary.dart';
import 'package:calora/features/home/presentation/widgets/home_header.dart';
import 'package:calora/features/home/presentation/widgets/home_macros.dart';
import 'package:calora/features/home/presentation/widgets/home_meals_section.dart';
import 'package:calora/features/home/presentation/widgets/home_water_card.dart';
import 'package:calora/features/home/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeProvider>();
    final diary = context.watch<DiaryProvider>();
    final profile = context.watch<AuthProvider>().profile;
    final dashboard = home.dashboard;
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
          CaloraSection(child: HomeCalorieSummary(dashboard: dashboard)),
          CaloraSection(child: HomeMacros(dashboard: dashboard)),
          CaloraSection(child: HomeWaterCard(dashboard: dashboard)),
          HomeMealsSection(diary: diary),
          SizedBox(height: AppSpacing.xxl.h),
        ],
      ),
    );
  }
}
