import 'dart:async';

import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_tokens.dart';
import 'package:calora/core/theme/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum MainTab { home, diary, progress, profile }

class MainBottomNavigation extends StatelessWidget {
  const MainBottomNavigation({super.key, required this.selectedTab});

  final MainTab selectedTab;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg.w,
            AppSpacing.md.h,
            AppSpacing.lg.w,
            AppSpacing.lg.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _item(context, MainTab.home, 'Home', Icons.home_outlined),
              _item(
                context,
                MainTab.diary,
                'Diary',
                Icons.description_outlined,
              ),
              Transform.translate(
                offset: Offset(0, -AppSpacing.sheet.h),
                child: Semantics(
                  button: true,
                  label: 'Scanner',
                  child: SizedBox(
                    width: AppSizes.navigationAction.w,
                    height: AppSizes.navigationAction.w,
                    child: IconButton(
                      tooltip: 'Scanner',
                      onPressed: () => unawaited(
                        Navigator.pushNamed(context, AppRoutes.scanner),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: context.colors.moss,
                        foregroundColor: context.colors.onAccent,
                        side: BorderSide(
                          color: context.colors.surface,
                          width: AppSpacing.xs.w,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadii.button.r,
                          ),
                        ),
                        shadowColor:
                            context.shadows.navigationAction.first.color,
                        elevation: AppElevations.high,
                      ),
                      icon: Icon(
                        Icons.photo_camera_outlined,
                        size: AppSizes.navigationIcon.sp,
                      ),
                    ),
                  ),
                ),
              ),
              _item(
                context,
                MainTab.progress,
                'Progress',
                Icons.bar_chart_outlined,
              ),
              _item(context, MainTab.profile, 'Profile', Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, MainTab tab, String label, IconData icon) {
    final selected = selectedTab == tab;
    return Expanded(
      child: InkWell(
        onTap: selected
            ? null
            : () => unawaited(
                Navigator.pushReplacementNamed(context, _routeFor(tab)),
              ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: AppSizes.navigationIcon.sp,
                color: selected ? context.colors.moss : context.colors.inkFaint,
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                label,
                maxLines: 1,
                style: context.textTheme.labelSmall?.copyWith(
                  color: selected
                      ? context.colors.moss
                      : context.colors.inkFaint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _routeFor(MainTab tab) => switch (tab) {
    MainTab.home => AppRoutes.home,
    MainTab.diary => AppRoutes.diary,
    MainTab.progress => AppRoutes.progress,
    MainTab.profile => AppRoutes.profile,
  };
}
