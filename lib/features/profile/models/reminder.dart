import 'package:cloud_firestore/cloud_firestore.dart';

enum ReminderKind { breakfast, lunch, dinner, water, weight, diary }

class Reminder {
  const Reminder({
    required this.kind,
    required this.enabled,
    required this.hour,
    required this.minute,
    this.waterIntervalMinutes,
    this.waterEndHour,
    this.waterEndMinute,
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
      waterIntervalMinutes: 120,
      waterEndHour: 20,
      waterEndMinute: 0,
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
    final waterIntervalMinutes = (data?['intervalMinutes'] as num?)?.toInt();
    final waterEndHour = (data?['endHour'] as num?)?.toInt();
    final waterEndMinute = (data?['endMinute'] as num?)?.toInt();
    final hasValidWaterEnd =
        waterEndHour != null &&
        waterEndHour >= 0 &&
        waterEndHour < 24 &&
        waterEndMinute != null &&
        waterEndMinute >= 0 &&
        waterEndMinute < 60;
    return Reminder(
      kind: kind,
      enabled: (data?['enabled'] as bool? ?? fallback.enabled) && hasValidTime,
      hour: hasValidTime ? hour : null,
      minute: hasValidTime ? minute : null,
      waterIntervalMinutes: kind == ReminderKind.water
          ? (waterIntervalMinutes != null && waterIntervalMinutes > 0
                ? waterIntervalMinutes
                : 120)
          : null,
      waterEndHour: kind == ReminderKind.water
          ? (hasValidWaterEnd ? waterEndHour : 20)
          : null,
      waterEndMinute: kind == ReminderKind.water
          ? (hasValidWaterEnd ? waterEndMinute : 0)
          : null,
    );
  }

  final ReminderKind kind;
  final bool enabled;
  final int? hour;
  final int? minute;
  final int? waterIntervalMinutes;
  final int? waterEndHour;
  final int? waterEndMinute;

  bool get hasTime => hour != null && minute != null;
  bool get hasWaterSchedule =>
      kind == ReminderKind.water &&
      hasTime &&
      waterIntervalMinutes != null &&
      waterIntervalMinutes! > 0 &&
      waterEndHour != null &&
      waterEndMinute != null &&
      _waterEndMinutes > _startMinutes;

  int get _startMinutes => hour! * 60 + minute!;
  int get _waterEndMinutes => waterEndHour! * 60 + waterEndMinute!;

  String get title => switch (kind) {
    ReminderKind.breakfast => 'Breakfast reminder',
    ReminderKind.lunch => 'Lunch reminder',
    ReminderKind.dinner => 'Dinner reminder',
    ReminderKind.water => 'Water reminder',
    ReminderKind.weight => 'Weight logging reminder',
    ReminderKind.diary => 'Daily logging reminder',
  };

  String get notificationBody => switch (kind) {
    ReminderKind.breakfast =>
      'Breakfast is the canvas upon which you paint your day.',
    ReminderKind.lunch =>
      'A nourishing lunch is a little kindness for your afternoon.',
    ReminderKind.dinner => 'Another dinner, another chance to be happy.',
    ReminderKind.water => 'A sip of water now keeps your day flowing.',
    ReminderKind.weight => 'Log your weight check-in.',
    ReminderKind.diary => 'Remember to complete today’s diary.',
  };

  String get scheduleLabel {
    if (kind == ReminderKind.water) {
      if (!hasWaterSchedule) return 'Choose an interval and active hours';
      return 'Every ${_intervalLabel(waterIntervalMinutes!)} · '
          '${_timeLabel(hour!, minute!)} – '
          '${_timeLabel(waterEndHour!, waterEndMinute!)}';
    }
    if (!hasTime) return 'Choose a time';
    final selectedHour = hour!;
    final selectedMinute = minute!;
    final suffix = selectedHour >= 12 ? 'PM' : 'AM';
    final shownHour = selectedHour % 12 == 0 ? 12 : selectedHour % 12;
    final time =
        '$shownHour:${selectedMinute.toString().padLeft(2, '0')} $suffix';
    return time;
  }

  Map<String, Object?> toMap() => <String, Object?>{
    'enabled': enabled,
    'hour': hour,
    'minute': minute,
    if (kind == ReminderKind.water) ...<String, Object?>{
      'intervalMinutes': waterIntervalMinutes,
      'endHour': waterEndHour,
      'endMinute': waterEndMinute,
    },
  };

  Reminder copyWith({
    bool? enabled,
    int? hour,
    int? minute,
    int? waterIntervalMinutes,
    int? waterEndHour,
    int? waterEndMinute,
  }) => Reminder(
    kind: kind,
    enabled: enabled ?? this.enabled,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    waterIntervalMinutes: waterIntervalMinutes ?? this.waterIntervalMinutes,
    waterEndHour: waterEndHour ?? this.waterEndHour,
    waterEndMinute: waterEndMinute ?? this.waterEndMinute,
  );

  String _intervalLabel(int minutes) {
    if (minutes % 60 == 0) {
      final hours = minutes ~/ 60;
      return '$hours ${hours == 1 ? 'hour' : 'hours'}';
    }
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
  }

  String _timeLabel(int hour, int minute) {
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final shownHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$shownHour:${minute.toString().padLeft(2, '0')} $suffix';
  }
}

class ReminderSettings {
  const ReminderSettings(this.reminders, {this.needsLegacyReset = false});

  factory ReminderSettings.defaults() => ReminderSettings(
    ReminderKind.values.map(Reminder.defaults).toList(growable: false),
  );

  factory ReminderSettings.fromMap(Map<String, dynamic>? data) {
    const schemaVersion = 3;
    final storedVersion = data?['schemaVersion'];
    if (storedVersion != 2 && storedVersion != schemaVersion) {
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
    'schemaVersion': 3,
    for (final reminder in reminders) reminder.kind.name: reminder.toMap(),
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
