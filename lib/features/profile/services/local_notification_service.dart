import 'package:calora/features/profile/models/reminder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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
  static const _waterNotificationBaseId = 1000;
  static const _maximumWaterNotifications = 50;
  bool _initialized = false;
  Future<void>? _initializing;

  Future<void> _initialize() async {
    if (_initialized) return;
    await (_initializing ??= _initializePlugin());
  }

  Future<void> _initializePlugin() async {
    try {
      tz.initializeTimeZones();
      final timezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezone.identifier));
      await _plugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
      );
      _initialized = true;
    } finally {
      _initializing = null;
    }
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
        for (var index = 0; index < _maximumWaterNotifications; index++) {
          await _plugin.cancel(_waterNotificationBaseId + index);
        }
        // Removes schedules made by versions that used the fixed two-hour plan.
        for (var index = 1; index < 7; index++) {
          await _plugin.cancel(_id(kind) + index);
        }
      }
    }
    for (final reminder in reminders.where((reminder) => reminder.enabled)) {
      if (reminder.kind == ReminderKind.water) {
        if (reminder.hasWaterSchedule) await _scheduleWater(reminder);
        continue;
      }
      if (!reminder.hasTime) continue;
      await _schedule(reminder, _id(reminder.kind));
    }
  }

  Future<void> _scheduleWater(Reminder reminder) async {
    final interval = reminder.waterIntervalMinutes!;
    final start = reminder.hour! * 60 + reminder.minute!;
    final end = reminder.waterEndHour! * 60 + reminder.waterEndMinute!;
    final count = ((end - start) ~/ interval) + 1;
    if (count > _maximumWaterNotifications) {
      throw ArgumentError(
        'The selected water schedule creates more than '
        '$_maximumWaterNotifications reminders a day.',
      );
    }
    for (var index = 0; index < count; index++) {
      final scheduledMinutes = start + index * interval;
      await _schedule(
        reminder,
        _waterNotificationBaseId + index,
        hour: scheduledMinutes ~/ 60,
        minute: scheduledMinutes % 60,
      );
    }
  }

  Future<void> _schedule(Reminder reminder, int id, {int? hour, int? minute}) {
    final scheduledHour = hour ?? reminder.hour!;
    final scheduledMinute = minute ?? reminder.minute!;
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = reminder.kind == ReminderKind.weight
        ? _nextSunday(now, scheduledHour, scheduledMinute)
        : tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            scheduledHour,
            scheduledMinute,
          );
    if (reminder.kind != ReminderKind.weight && !scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
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
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: reminder.kind == ReminderKind.weight
          ? DateTimeComponents.dayOfWeekAndTime
          : DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextSunday(tz.TZDateTime now, int hour, int minute) {
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    final daysUntilSunday = (DateTime.sunday - scheduled.weekday) % 7;
    scheduled = scheduled.add(Duration(days: daysUntilSunday));
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }
    return scheduled;
  }

  int _id(ReminderKind kind) => 700 + kind.index * 10;
}
