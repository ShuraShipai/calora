import 'package:calora/app/providers/theme_provider.dart';
import 'package:calora/app/router/app_router.dart';
import 'package:calora/app/router/app_routes.dart';
import 'package:calora/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CaloraApp extends StatelessWidget {
  const CaloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, child) => MaterialApp(
        title: 'Calora',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
        onUnknownRoute: AppRouter.onUnknownRoute,
      ),
    );
  }
}
