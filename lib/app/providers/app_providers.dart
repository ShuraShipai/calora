import 'package:calora/app/providers/theme_provider.dart';
import 'package:calora/app/services/theme_preferences_service.dart';
import 'package:calora/core/network/network_client.dart';
import 'package:calora/core/network/network_connectivity_service.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/auth/services/account_deletion_service.dart';
import 'package:calora/features/auth/services/auth_service.dart';
import 'package:calora/features/auth/services/user_profile_service.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/diary/services/diary_service.dart';
import 'package:calora/features/profile/providers/data_export_provider.dart';
import 'package:calora/features/profile/providers/reminder_provider.dart';
import 'package:calora/features/profile/services/data_export_service.dart';
import 'package:calora/features/profile/services/local_notification_service.dart';
import 'package:calora/features/profile/services/reminder_service.dart';
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
  Provider<AccountDeletionService>(
    create: (_) => FirebaseAccountDeletionService(),
  ),
  Provider<UserProfileService>(create: (_) => FirestoreUserProfileService()),
  Provider<DiaryService>(create: (_) => FirestoreDiaryService()),
  Provider<ProgressService>(create: (_) => FirestoreProgressService()),
  Provider<ReminderService>(create: (_) => FirestoreReminderService()),
  Provider<DataExportService>(create: (_) => ShareDataExportService()),
  Provider<LocalNotificationService>(
    create: (_) => FlutterLocalNotificationService(),
  ),
  Provider<NetworkConnectivityService>(
    create: (_) => ConnectivityPlusNetworkConnectivityService(),
  ),
  Provider<NetworkClient>(
    create: (context) => DioNetworkClient(
      connectivity: context.read<NetworkConnectivityService>(),
    ),
  ),
  Provider<FoodProductLookupService>(
    create: (context) => OpenFoodFactsProductLookupService(
      networkClient: context.read<NetworkClient>(),
    ),
  ),
  Provider<BarcodeScannerService>(create: (_) => BarcodeScannerService()),
  ChangeNotifierProvider<AuthProvider>(
    create: (context) => AuthProvider(
      context.read<AuthService>(),
      context.read<UserProfileService>(),
      accountDeletionService: context.read<AccountDeletionService>(),
    ),
  ),
  ChangeNotifierProxyProvider<AuthProvider, DiaryProvider>(
    create: (context) => DiaryProvider(context.read<DiaryService>()),
    update: (_, auth, diary) => diary!..updateUser(auth.profile),
  ),
  ChangeNotifierProxyProvider<AuthProvider, ProgressProvider>(
    create: (context) => ProgressProvider(context.read<ProgressService>()),
    update: (_, auth, progress) => progress!..updateUser(auth.profile),
  ),
  ChangeNotifierProxyProvider<AuthProvider, ReminderProvider>(
    create: (context) => ReminderProvider(
      context.read<ReminderService>(),
      context.read<LocalNotificationService>(),
    ),
    update: (_, auth, reminders) {
      final provider = reminders!;
      // A restored Firebase session is briefly unresolved at startup. Keep
      // existing device schedules until that state resolves; only a resolved
      // signed-out state should clear them.
      if (auth.status != AuthStatus.initializing) {
        provider.updateUser(auth.profile?.uid);
      }
      return provider;
    },
  ),
  ChangeNotifierProvider<DataExportProvider>(
    create: (context) => DataExportProvider(context.read<DataExportService>()),
  ),
  ChangeNotifierProvider<BarcodeLookupProvider>(
    create: (context) =>
        BarcodeLookupProvider(context.read<FoodProductLookupService>()),
  ),
  ChangeNotifierProvider<ScannerProvider>(
    create: (context) => ScannerProvider(context.read<BarcodeScannerService>()),
  ),
];
