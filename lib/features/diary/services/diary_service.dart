import 'package:calora/features/diary/models/diary_entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class DiaryService {
  Stream<List<DiaryEntry>> watchEntries(String uid);
  Future<void> addEntry(String uid, DiaryEntry entry);
  Future<void> deleteEntry(String uid, String entryId);
}

class FirestoreDiaryService implements DiaryService {
  FirestoreDiaryService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _entries(String uid) =>
      _firestore.collection('users').doc(uid).collection('diaryEntries');

  @override
  Stream<List<DiaryEntry>> watchEntries(String uid) => _entries(uid)
      .orderBy('loggedAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map(DiaryEntry.fromDocument).toList());

  @override
  Future<void> addEntry(String uid, DiaryEntry entry) =>
      _entries(uid).add(entry.toMap());

  @override
  Future<void> deleteEntry(String uid, String entryId) =>
      _entries(uid).doc(entryId).delete();
}
