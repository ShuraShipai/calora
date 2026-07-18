import 'dart:async';

import 'package:calora/features/profile/models/reminder.dart';
import 'package:calora/features/profile/providers/reminder_provider.dart';
import 'package:calora/features/profile/services/local_notification_service.dart';
import 'package:calora/features/profile/services/reminder_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReminderProvider', () {
    late _FakeReminderService reminders;
    late _FakeNotifications notifications;
    late ReminderProvider provider;

    setUp(() {
      reminders = _FakeReminderService();
      notifications = _FakeNotifications();
      provider = ReminderProvider(reminders, notifications);
    });

    test('serializes water schedules with the current schema version', () {
      final settings = ReminderSettings(<Reminder>[
        Reminder.defaults(ReminderKind.breakfast),
        Reminder.defaults(ReminderKind.lunch),
        Reminder.defaults(ReminderKind.dinner),
        const Reminder(
          kind: ReminderKind.water,
          enabled: true,
          hour: 8,
          minute: 0,
          waterIntervalMinutes: 45,
          waterEndHour: 20,
          waterEndMinute: 0,
        ),
        Reminder.defaults(ReminderKind.weight),
        Reminder.defaults(ReminderKind.diary),
      ]);

      final data = settings.toMap();
      final restored = ReminderSettings.fromMap(<String, dynamic>{...data});
      final water = restored.reminders.firstWhere(
        (reminder) => reminder.kind == ReminderKind.water,
      );

      expect(data['schemaVersion'], 3);
      expect(water.hasWaterSchedule, isTrue);
      expect(water.waterIntervalMinutes, 45);
    });

    test('schedules loaded reminders for the active user', () async {
      final settings = ReminderSettings.defaults();
      reminders.settings = settings;

      await provider.updateUser('user-1');

      expect(reminders.loadedUid, 'user-1');
      expect(notifications.synced, <List<Reminder>>[settings.reminders]);
      expect(provider.isLoading, isFalse);
    });

    test('clears device reminders when no user is signed in', () async {
      await provider.updateUser(null);

      expect(notifications.synced, hasLength(1));
      expect(notifications.synced.single, isEmpty);
    });

    test('resets legacy preset schedules before syncing the device', () async {
      reminders.settings = ReminderSettings.fromMap(<String, dynamic>{
        'breakfast': <String, dynamic>{'enabled': true, 'hour': 8, 'minute': 0},
      });

      await provider.updateUser('user-1');

      expect(
        provider.reminders,
        everyElement(predicate<Reminder>((reminder) => !reminder.hasTime)),
      );
      expect(reminders.savedSettings?.needsLegacyReset, isTrue);
      expect(
        notifications.synced.single,
        everyElement(predicate<Reminder>((reminder) => !reminder.enabled)),
      );
    });

    test(
      'does not request permission for reminders without a selected time',
      () async {
        await provider.updateUser('user-1');

        final permitted = await provider.requestPermissionForEnabledReminders();

        expect(permitted, isTrue);
        expect(notifications.permissionRequests, 0);
      },
    );

    test('requires a selected time before enabling a reminder', () async {
      await provider.updateUser('user-1');

      final saved = await provider.save(
        provider.reminders.first.copyWith(enabled: true),
      );

      expect(saved, isFalse);
      expect(reminders.savedSettings, isNull);
      expect(
        provider.errorMessage,
        'Choose a time before enabling this reminder.',
      );
    });

    test('requires a complete water schedule before enabling it', () async {
      await provider.updateUser('user-1');
      final water = provider.reminders.firstWhere(
        (reminder) => reminder.kind == ReminderKind.water,
      );

      final saved = await provider.save(water.copyWith(enabled: true));

      expect(saved, isFalse);
      expect(reminders.savedSettings, isNull);
      expect(
        provider.errorMessage,
        'Choose a valid interval, start time, and end time first.',
      );
    });

    test('saves and reschedules a configured water reminder', () async {
      await provider.updateUser('user-1');
      final water = provider.reminders.firstWhere(
        (reminder) => reminder.kind == ReminderKind.water,
      );
      final configured = water.copyWith(
        enabled: true,
        hour: 8,
        minute: 0,
        waterIntervalMinutes: 45,
        waterEndHour: 20,
        waterEndMinute: 0,
      );

      final saved = await provider.save(configured);

      expect(saved, isTrue);
      final savedWater = reminders.savedSettings!.reminders.firstWhere(
        (reminder) => reminder.kind == ReminderKind.water,
      );
      expect(savedWater.waterIntervalMinutes, 45);
      expect(savedWater.waterEndHour, 20);
      expect(notifications.synced.last, contains(savedWater));
    });

    test('does not save while the active user settings are loading', () async {
      final loading = Completer<ReminderSettings>();
      reminders.loadOverride = (_) => loading.future;
      final loadingUpdate = provider.updateUser('user-1');

      final saved = await provider.save(
        provider.reminders.first.copyWith(enabled: true, hour: 8, minute: 0),
      );

      expect(saved, isFalse);
      expect(reminders.savedSettings, isNull);

      loading.complete(ReminderSettings.defaults());
      await loadingUpdate;
    });

    test('keeps the saved setting when device scheduling fails', () async {
      notifications.failSync = true;
      await provider.updateUser('user-1');
      notifications.failSync = true;
      final updated = provider.reminders.first.copyWith(enabled: false);

      final saved = await provider.save(updated);

      expect(saved, isFalse);
      expect(reminders.savedSettings?.reminders.first.enabled, isFalse);
      expect(provider.reminders.first.enabled, isFalse);
      expect(provider.errorMessage, contains('could not be scheduled'));
    });

    test(
      'does not save an enabled reminder when permission is denied',
      () async {
        await provider.updateUser('user-1');
        notifications.permissionGranted = false;

        final saved = await provider.save(
          provider.reminders.first.copyWith(enabled: true, hour: 8, minute: 0),
        );

        expect(saved, isFalse);
        expect(reminders.savedSettings, isNull);
        expect(provider.errorMessage, contains('Notifications are disabled'));
      },
    );
  });
}

class _FakeReminderService implements ReminderService {
  ReminderSettings settings = ReminderSettings.defaults();
  String? loadedUid;
  ReminderSettings? savedSettings;
  Future<ReminderSettings> Function(String uid)? loadOverride;

  @override
  Future<ReminderSettings> load(String uid) async {
    loadedUid = uid;
    return loadOverride?.call(uid) ?? settings;
  }

  @override
  Future<void> save(String uid, ReminderSettings settings) async {
    savedSettings = settings;
  }
}

class _FakeNotifications implements LocalNotificationService {
  bool permissionGranted = true;
  bool failSync = false;
  int permissionRequests = 0;
  final List<List<Reminder>> synced = <List<Reminder>>[];

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return permissionGranted;
  }

  @override
  Future<void> syncReminders(List<Reminder> reminders) async {
    synced.add(reminders);
    if (failSync) throw StateError('Scheduling unavailable');
  }
}
