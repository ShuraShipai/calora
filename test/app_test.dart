import 'dart:async';

import 'package:calora/app/calora_app.dart';
import 'package:calora/app/providers/theme_provider.dart';
import 'package:calora/app/router/app_routes.dart';
import 'package:calora/app/services/theme_preferences_service.dart';
import 'package:calora/core/models/daily_goal_status.dart';
import 'package:calora/core/theme/app_colors.dart';
import 'package:calora/core/theme/app_theme.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/diary/services/diary_service.dart';
import 'package:calora/features/profile/models/reminder.dart';
import 'package:calora/features/profile/providers/data_export_provider.dart';
import 'package:calora/features/profile/providers/reminder_provider.dart';
import 'package:calora/features/profile/services/data_export_service.dart';
import 'package:calora/features/profile/services/local_notification_service.dart';
import 'package:calora/features/profile/services/reminder_service.dart';
import 'package:calora/features/progress/models/water_entry.dart';
import 'package:calora/features/progress/models/weight_entry.dart';
import 'package:calora/features/progress/providers/progress_provider.dart';
import 'package:calora/features/progress/services/progress_service.dart';
import 'package:calora/features/scanner/models/scan_result_outcome.dart';
import 'package:calora/features/scanner/providers/scanner_provider.dart';
import 'package:calora/features/scanner/services/barcode_scanner_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'support/fake_auth_dependencies.dart';

void main() {
  testWidgets('boots into the design splash screen', (tester) async {
    await tester.pumpWidget(_testApp());

    expect(find.text('Calora'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('splash')), findsOneWidget);
  });

  testWidgets('scan results can return a typed barcode outcome', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));

    final outcome = navigator.pushNamed<ScanResultOutcome>(
      AppRoutes.scanResults,
    );
    await tester.pumpAndSettle();
    navigator.pop(ScanResultOutcome.saved);

    expect(await outcome, ScanResultOutcome.saved);
  });

  for (final themeMode in <ThemeMode>[ThemeMode.light, ThemeMode.dark]) {
    testWidgets('every design screen opens in $themeMode', (tester) async {
      await tester.pumpWidget(_testApp(themeMode: themeMode));

      for (final routeName in AppRoutes.all.where((route) => route != '/')) {
        final navigator = tester.state<NavigatorState>(find.byType(Navigator));
        unawaited(navigator.pushNamed(routeName));
        await tester.pumpAndSettle();

        expect(
          ModalRoute.of(
            tester.element(find.byType(Scaffold).last),
          )?.settings.name,
          routeName,
        );
        navigator.pop();
        await tester.pumpAndSettle();
      }
    });
  }

  test('themes use Material 3 and expose matching token extensions', () {
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.dark.useMaterial3, isTrue);
    expect(AppTheme.light.extension<AppColors>(), AppColors.light);
    expect(AppTheme.dark.extension<AppColors>(), AppColors.dark);
    expect(AppTheme.light.scaffoldBackgroundColor, AppColors.light.canvas);
    expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.dark.canvas);
  });
}

Widget _testApp({ThemeMode themeMode = ThemeMode.system}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(
          preferences: _FakeThemePreferences(),
          initialThemeMode: themeMode,
        ),
      ),
      ChangeNotifierProvider<AuthProvider>(
        create: (_) =>
            AuthProvider(FakeAuthService(), FakeUserProfileService()),
      ),
      ChangeNotifierProvider<DiaryProvider>(
        create: (_) => DiaryProvider(_EmptyDiaryService()),
      ),
      ChangeNotifierProvider<ProgressProvider>(
        create: (_) => ProgressProvider(_EmptyProgressService()),
      ),
      ChangeNotifierProvider<ScannerProvider>(
        create: (_) => ScannerProvider(BarcodeScannerService()),
      ),
      ChangeNotifierProvider<ReminderProvider>(
        create: (_) => ReminderProvider(
          _EmptyReminderService(),
          _EmptyLocalNotificationService(),
        ),
      ),
      ChangeNotifierProvider<DataExportProvider>(
        create: (_) => DataExportProvider(_EmptyDataExportService()),
      ),
    ],
    child: const CaloraApp(),
  );
}

class _FakeThemePreferences implements ThemePreferencesService {
  @override
  Future<ThemeMode> loadThemeMode() async => ThemeMode.system;

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {}
}

class _EmptyDiaryService implements DiaryService {
  @override
  Future<void> addEntry(String uid, DiaryEntry entry) async {}

  @override
  Future<void> deleteEntry(String uid, String entryId) async {}

  @override
  Future<void> updateEntry(String uid, DiaryEntry entry) async {}

  @override
  Stream<List<DiaryEntry>> watchEntries(String uid) =>
      Stream<List<DiaryEntry>>.value(const <DiaryEntry>[]);
}

class _EmptyProgressService implements ProgressService {
  @override
  Future<void> addWaterEntry(String uid, WaterEntry entry) async {}

  @override
  Future<void> addWeightEntry(String uid, WeightEntry entry) async {}

  @override
  Stream<List<WaterEntry>> watchWaterEntries(String uid) =>
      Stream<List<WaterEntry>>.value(const <WaterEntry>[]);

  @override
  Stream<List<WeightEntry>> watchWeightEntries(String uid) =>
      Stream<List<WeightEntry>>.value(const <WeightEntry>[]);
}

class _EmptyReminderService implements ReminderService {
  @override
  Future<ReminderSettings> load(String uid) async =>
      ReminderSettings.defaults();

  @override
  Future<void> save(String uid, ReminderSettings settings) async {}
}

class _EmptyLocalNotificationService implements LocalNotificationService {
  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> syncReminders(List<Reminder> reminders) async {}
}

class _EmptyDataExportService implements DataExportService {
  @override
  Future<void> export({
    required List<DiaryEntry> diaryEntries,
    required List<WaterEntry> waterEntries,
    required List<WeightEntry> weightEntries,
    required List<DailyGoalStatus> dailyGoals,
  }) async {}
}
