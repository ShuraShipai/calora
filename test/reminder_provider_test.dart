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

  @override
  Future<ReminderSettings> load(String uid) async {
    loadedUid = uid;
    return settings;
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
