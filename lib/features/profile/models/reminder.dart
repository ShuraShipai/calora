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
      enabled: false,
      hour: null,
      minute: null,
    ),
    ReminderKind.lunch => Reminder(
      kind: kind,
      enabled: false,
      hour: null,
      minute: null,
    ),
    ReminderKind.dinner => Reminder(
      kind: kind,
      enabled: false,
      hour: null,
      minute: null,
    ),
    ReminderKind.water => Reminder(
      kind: kind,
      enabled: false,
      hour: null,
      minute: null,
    ),
    ReminderKind.weight => Reminder(
      kind: kind,
      enabled: false,
      hour: null,
      minute: null,
    ),
    ReminderKind.diary => Reminder(
      kind: kind,
      enabled: false,
      hour: null,
      minute: null,
    ),
  };

  factory Reminder.fromMap(ReminderKind kind, Map<String, dynamic>? data) {
    final fallback = Reminder.defaults(kind);
    final hour = (data?['hour'] as num?)?.toInt();
    final minute = (data?['minute'] as num?)?.toInt();
    final hasValidTime =
        hour != null &&
        hour >= 0 &&
        hour < 24 &&
        minute != null &&
        minute >= 0 &&
        minute < 60;
    return Reminder(
      kind: kind,
      enabled: (data?['enabled'] as bool? ?? fallback.enabled) && hasValidTime,
      hour: hasValidTime ? hour : null,
      minute: hasValidTime ? minute : null,
    );
  }

  final ReminderKind kind;
  final bool enabled;
  final int? hour;
  final int? minute;

  bool get hasTime => hour != null && minute != null;

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
    if (!hasTime) return 'Choose a time';
    final selectedHour = hour!;
    final selectedMinute = minute!;
    final suffix = selectedHour >= 12 ? 'PM' : 'AM';
    final shownHour = selectedHour % 12 == 0 ? 12 : selectedHour % 12;
    final time =
        '$shownHour:${selectedMinute.toString().padLeft(2, '0')} $suffix';
    return switch (kind) {
      ReminderKind.water => 'Every 2 hours from $time',
      ReminderKind.weight => 'Sundays, $time',
      ReminderKind.diary => time,
      _ => time,
    };
  }

  Map<String, Object?> toMap() => <String, Object?>{
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
  const ReminderSettings(this.reminders, {this.needsLegacyReset = false});

  factory ReminderSettings.defaults() => ReminderSettings(
    ReminderKind.values.map(Reminder.defaults).toList(growable: false),
  );

  factory ReminderSettings.fromMap(Map<String, dynamic>? data) {
    const schemaVersion = 2;
    if (data?['schemaVersion'] != schemaVersion) {
      return ReminderSettings(
        ReminderKind.values.map(Reminder.defaults).toList(growable: false),
        needsLegacyReset: data != null,
      );
    }
    return ReminderSettings(
      ReminderKind.values
          .map(
            (kind) => Reminder.fromMap(
              kind,
              data?[kind.name] as Map<String, dynamic>?,
            ),
          )
          .toList(growable: false),
    );
  }

  final List<Reminder> reminders;
  final bool needsLegacyReset;

  Map<String, Object?> toMap() => <String, Object?>{
    'schemaVersion': 2,
    for (final reminder in reminders) reminder.kind.name: reminder.toMap(),
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
