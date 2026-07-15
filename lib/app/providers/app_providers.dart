import 'package:calora/app/providers/theme_provider.dart';
import 'package:calora/app/services/theme_preferences_service.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/auth/services/auth_service.dart';
import 'package:calora/features/auth/services/user_profile_service.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/diary/services/diary_service.dart';
import 'package:calora/features/home/providers/home_provider.dart';
import 'package:calora/features/home/services/home_dashboard_service.dart';
import 'package:calora/features/progress/providers/progress_provider.dart';
import 'package:calora/features/progress/services/progress_service.dart';
import 'package:calora/features/scanner/providers/barcode_lookup_provider.dart';
import 'package:calora/features/scanner/providers/scanner_provider.dart';
import 'package:calora/features/scanner/services/barcode_scanner_service.dart';
import 'package:calora/features/scanner/services/food_product_lookup_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> appProviders({
  required ThemePreferencesService themePreferences,
  required ThemeMode initialThemeMode,
}) => <SingleChildWidget>[
  Provider<ThemePreferencesService>.value(value: themePreferences),
  ChangeNotifierProvider<ThemeProvider>(
    create: (context) => ThemeProvider(
      preferences: context.read<ThemePreferencesService>(),
      initialThemeMode: initialThemeMode,
    ),
  ),
  Provider<AuthService>(create: (_) => FirebaseAuthService()),
  Provider<UserProfileService>(create: (_) => FirestoreUserProfileService()),
  Provider<HomeDashboardService>(
    create: (_) => FirestoreHomeDashboardService(),
  ),
  Provider<DiaryService>(create: (_) => FirestoreDiaryService()),
  Provider<ProgressService>(create: (_) => FirestoreProgressService()),
  Provider<FoodProductLookupService>(
    create: (_) => OpenFoodFactsProductLookupService(),
  ),
  Provider<BarcodeScannerService>(create: (_) => BarcodeScannerService()),
  ChangeNotifierProvider<AuthProvider>(
    create: (context) => AuthProvider(
      context.read<AuthService>(),
      context.read<UserProfileService>(),
    ),
  ),
  ChangeNotifierProxyProvider<AuthProvider, HomeProvider>(
    create: (context) => HomeProvider(context.read<HomeDashboardService>()),
    update: (_, auth, home) => home!..updateUser(auth.profile),
  ),
  ChangeNotifierProxyProvider<AuthProvider, DiaryProvider>(
    create: (context) => DiaryProvider(context.read<DiaryService>()),
    update: (_, auth, diary) => diary!..updateUser(auth.profile),
  ),
  ChangeNotifierProxyProvider<AuthProvider, ProgressProvider>(
    create: (context) => ProgressProvider(context.read<ProgressService>()),
    update: (_, auth, progress) => progress!..updateUser(auth.profile),
  ),
  ChangeNotifierProvider<BarcodeLookupProvider>(
    create: (context) =>
        BarcodeLookupProvider(context.read<FoodProductLookupService>()),
  ),
  ChangeNotifierProvider<ScannerProvider>(
    create: (context) => ScannerProvider(context.read<BarcodeScannerService>()),
  ),
];
