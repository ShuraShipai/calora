import 'package:calora/app/widgets/main_bottom_navigation.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/widgets/calora_page.dart';
import 'package:calora/features/diary/presentation/widgets/diary_dashboard.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diary = context.watch<DiaryProvider>();
    return CaloraPage(
      screenId: 'diary',
      bottomNavigationBar: const MainBottomNavigation(
        selectedTab: MainTab.diary,
      ),
      child: ListView(
        padding: const EdgeInsets.only(top: AppSpacing.sm),
        children: <Widget>[DiaryDashboard(diary: diary)],
      ),
    );
  }
}
