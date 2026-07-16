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
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  List<Reminder> get reminders => _settings.reminders;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  Future<void> updateUser(String? uid) async {
    if (_uid == uid) return;
    _uid = uid;
    _settings = ReminderSettings.defaults();
    _errorMessage = null;
    if (uid == null) {
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      _settings = await _service.load(uid);
    } catch (_) {
      _errorMessage = 'Could not load reminders.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> save(Reminder updated) async {
    final uid = _uid;
    if (uid == null) return false;
    if (updated.enabled && !await _notifications.requestPermission()) {
      _errorMessage = 'Notifications are disabled. Enable them in Settings.';
      notifyListeners();
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
      await _service.save(uid, _settings);
      await _notifications.syncReminders(_settings.reminders);
      return true;
    } catch (_) {
      _settings = previous;
      _errorMessage = 'Could not save reminder.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
