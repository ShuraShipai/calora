import 'package:calora/features/profile/models/reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ReminderService {
  Future<ReminderSettings> load(String uid);
  Future<void> save(String uid, ReminderSettings settings);
}

class FirestoreReminderService implements ReminderService {
  FirestoreReminderService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _settings(String uid) => _firestore
      .collection('users')
      .doc(uid)
      .collection('settings')
      .doc('reminders');

  @override
  Future<ReminderSettings> load(String uid) async =>
      ReminderSettings.fromMap((await _settings(uid).get()).data());

  @override
  Future<void> save(String uid, ReminderSettings settings) =>
      _settings(uid).set(settings.toMap(), SetOptions(merge: true));
}
