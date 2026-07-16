import 'package:cloud_firestore/cloud_firestore.dart';

enum ReminderKind { breakfast, lunch, dinner, water, weight, diary }

class Reminder {
  const Reminder({
    required this.kind,
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  factory Reminder.defaults(ReminderKind kind) => switch (kind) {
    ReminderKind.breakfast => Reminder(
      kind: kind,
      enabled: true,
      hour: 8,
      minute: 0,
    ),
    ReminderKind.lunch => Reminder(
      kind: kind,
      enabled: true,
      hour: 13,
      minute: 0,
    ),
    ReminderKind.dinner => Reminder(
      kind: kind,
      enabled: false,
      hour: 20,
      minute: 0,
    ),
    ReminderKind.water => Reminder(
      kind: kind,
      enabled: true,
      hour: 9,
      minute: 0,
    ),
    ReminderKind.weight => Reminder(
      kind: kind,
      enabled: true,
      hour: 9,
      minute: 0,
    ),
    ReminderKind.diary => Reminder(
      kind: kind,
      enabled: false,
      hour: 21,
      minute: 30,
    ),
  };

  factory Reminder.fromMap(ReminderKind kind, Map<String, dynamic>? data) {
    final fallback = Reminder.defaults(kind);
    return Reminder(
      kind: kind,
      enabled: data?['enabled'] as bool? ?? fallback.enabled,
      hour: (data?['hour'] as num?)?.toInt() ?? fallback.hour,
      minute: (data?['minute'] as num?)?.toInt() ?? fallback.minute,
    );
  }

  final ReminderKind kind;
  final bool enabled;
  final int hour;
  final int minute;

  String get title => switch (kind) {
    ReminderKind.breakfast => 'Breakfast reminder',
    ReminderKind.lunch => 'Lunch reminder',
    ReminderKind.dinner => 'Dinner reminder',
    ReminderKind.water => 'Water reminder',
    ReminderKind.weight => 'Weight logging reminder',
    ReminderKind.diary => 'Daily logging reminder',
  };

  String get notificationBody => switch (kind) {
    ReminderKind.breakfast => 'Remember to log breakfast in Calora.',
    ReminderKind.lunch => 'Remember to log lunch in Calora.',
    ReminderKind.dinner => 'Remember to log dinner in Calora.',
    ReminderKind.water => 'Time for a glass of water.',
    ReminderKind.weight => 'Log your weekly weight check-in.',
    ReminderKind.diary => 'Remember to complete today’s diary.',
  };

  String get scheduleLabel {
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final shownHour = hour % 12 == 0 ? 12 : hour % 12;
    final time = '$shownHour:${minute.toString().padLeft(2, '0')} $suffix';
    return switch (kind) {
      ReminderKind.water => 'Every 2 hours from $time',
      ReminderKind.weight => 'Sundays, $time',
      ReminderKind.diary => '$time',
      _ => time,
    };
  }

  Map<String, Object> toMap() => <String, Object>{
    'enabled': enabled,
    'hour': hour,
    'minute': minute,
  };

  Reminder copyWith({bool? enabled, int? hour, int? minute}) => Reminder(
    kind: kind,
    enabled: enabled ?? this.enabled,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
  );
}

class ReminderSettings {
  const ReminderSettings(this.reminders);

  factory ReminderSettings.defaults() => ReminderSettings(
    ReminderKind.values.map(Reminder.defaults).toList(growable: false),
  );

  factory ReminderSettings.fromMap(Map<String, dynamic>? data) =>
      ReminderSettings(
        ReminderKind.values
            .map(
              (kind) => Reminder.fromMap(
                kind,
                data?[kind.name] as Map<String, dynamic>?,
              ),
            )
            .toList(growable: false),
      );

  final List<Reminder> reminders;

  Map<String, Object> toMap() => <String, Object>{
    for (final reminder in reminders) reminder.kind.name: reminder.toMap(),
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
