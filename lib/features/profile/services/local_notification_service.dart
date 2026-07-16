import 'package:calora/features/profile/models/reminder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract interface class LocalNotificationService {
  Future<bool> requestPermission();
  Future<void> syncReminders(List<Reminder> reminders);
}

class FlutterLocalNotificationService implements LocalNotificationService {
  FlutterLocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  Future<void> _initialize() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    _initialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    await _initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final androidAllowed = await android?.requestNotificationsPermission();
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosAllowed = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    return androidAllowed ?? iosAllowed ?? true;
  }

  @override
  Future<void> syncReminders(List<Reminder> reminders) async {
    await _initialize();
    for (final kind in ReminderKind.values) {
      await _plugin.cancel(_id(kind));
      if (kind == ReminderKind.water) {
        for (var index = 1; index < 7; index++) {
          await _plugin.cancel(_id(kind) + index);
        }
      }
    }
    for (final reminder in reminders.where((reminder) => reminder.enabled)) {
      if (reminder.kind == ReminderKind.water) {
        for (var index = 0; index < 7; index++) {
          await _schedule(
            reminder,
            _id(reminder.kind) + index,
            hourOffset: index * 2,
          );
        }
      } else {
        await _schedule(reminder, _id(reminder.kind));
      }
    }
  }

  Future<void> _schedule(Reminder reminder, int id, {int hourOffset = 0}) {
    final hour = (reminder.hour + hourOffset) % 24;
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      reminder.minute,
    );
    if (!scheduled.isAfter(now))
      scheduled = scheduled.add(const Duration(days: 1));
    return _plugin.zonedSchedule(
      id,
      reminder.title,
      reminder.notificationBody,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders',
          'Reminders',
          channelDescription: 'Calora health reminders',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: reminder.kind == ReminderKind.weight
          ? DateTimeComponents.dayOfWeekAndTime
          : DateTimeComponents.time,
    );
  }

  int _id(ReminderKind kind) => 700 + kind.index * 10;
}
