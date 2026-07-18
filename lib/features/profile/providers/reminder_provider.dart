import 'package:calora/features/profile/models/reminder.dart';
import 'package:calora/features/profile/services/local_notification_service.dart';
import 'package:calora/features/profile/services/reminder_service.dart';
import 'package:flutter/foundation.dart';

class ReminderProvider extends ChangeNotifier {
  ReminderProvider(this._service, this._notifications);

  final ReminderService _service;
  final LocalNotificationService _notifications;
  ReminderSettings _settings = ReminderSettings.defaults();
  String? _uid;
  bool _hasResolvedUser = false;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  List<Reminder> get reminders => _settings.reminders;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  Future<bool> requestPermissionForEnabledReminders() async {
    if (!_settings.reminders.any(
      (reminder) =>
          reminder.enabled &&
          (reminder.kind == ReminderKind.water
              ? reminder.hasWaterSchedule
              : reminder.hasTime),
    )) {
      return true;
    }
    return _requestNotificationPermission();
  }

  Future<bool> _requestNotificationPermission() async {
    try {
      if (await _notifications.requestPermission()) return true;
      _errorMessage = 'Notifications are disabled. Enable them in Settings.';
    } catch (_) {
      _errorMessage = 'Could not request notification permission.';
    }
    notifyListeners();
    return false;
  }

  Future<void> updateUser(String? uid) async {
    if (_hasResolvedUser && _uid == uid) return;
    _hasResolvedUser = true;
    _uid = uid;
    _settings = ReminderSettings.defaults();
    _errorMessage = null;
    if (uid == null) {
      try {
        await _notifications.syncReminders(const <Reminder>[]);
      } catch (_) {
        // A failed cleanup must not prevent sign-out.
      }
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final settings = await _service.load(uid);
      if (_uid != uid) return;
      _settings = settings;
      if (settings.needsLegacyReset) {
        await _service.save(uid, settings);
      }
      await _notifications.syncReminders(settings.reminders);
    } catch (_) {
      if (_uid == uid) _errorMessage = 'Could not load reminders.';
    } finally {
      if (_uid == uid) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> save(Reminder updated) async {
    final uid = _uid;
    if (uid == null || _isLoading || _isSaving) return false;
    if (updated.enabled &&
        (updated.kind == ReminderKind.water
            ? !updated.hasWaterSchedule
            : !updated.hasTime)) {
      _errorMessage = updated.kind == ReminderKind.water
          ? 'Choose a valid interval, start time, and end time first.'
          : 'Choose a time before enabling this reminder.';
      notifyListeners();
      return false;
    }
    if (updated.enabled && !await _requestNotificationPermission()) {
      return false;
    }
    final previous = _settings;
    _settings = ReminderSettings(
      previous.reminders
          .map((item) => item.kind == updated.kind ? updated : item)
          .toList(growable: false),
    );
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      try {
        await _notifications.syncReminders(_settings.reminders);
      } catch (_) {
        _settings = previous;
        _errorMessage = 'Could not schedule this reminder on this device.';
        return false;
      }
      try {
        await _service.save(uid, _settings);
      } catch (_) {
        _settings = previous;
        try {
          await _notifications.syncReminders(previous.reminders);
        } catch (_) {
          // The persistence error is the actionable result for this save.
        }
        _errorMessage = 'Could not save reminder.';
        return false;
      }
      return true;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
