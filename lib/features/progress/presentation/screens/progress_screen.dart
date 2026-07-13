import 'package:calora/app/router/app_routes.dart';
import 'package:calora/app/widgets/main_bottom_navigation.dart';
import 'package:calora/core/widgets/calora_screen_scaffold.dart';
import 'package:calora/features/progress/presentation/widgets/progress_page_body.dart';
import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  var _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return CaloraScreenScaffold(
      screenId: 'progress',
      body: ProgressPageBody(
        selectedFilter: _selectedFilter,
        onFilterSelected: (index) => setState(() => _selectedFilter = index),
        onWeightPressed: () => Navigator.pushNamed(context, AppRoutes.weight),
      ),
      bottomNavigationBar: const MainBottomNavigation(
        selectedTab: MainTab.progress,
      ),
    );
  }
}
