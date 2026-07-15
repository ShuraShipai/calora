import 'package:calora/features/progress/models/water_entry.dart';
import 'package:calora/features/progress/models/weight_entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ProgressService {
  Stream<List<WaterEntry>> watchWaterEntries(String uid);
  Future<void> addWaterEntry(String uid, WaterEntry entry);
  Stream<List<WeightEntry>> watchWeightEntries(String uid);
  Future<void> addWeightEntry(String uid, WeightEntry entry);
}

class FirestoreProgressService implements ProgressService {
  FirestoreProgressService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _waterEntries(String uid) =>
      _firestore.collection('users').doc(uid).collection('waterEntries');
  CollectionReference<Map<String, dynamic>> _weightEntries(String uid) =>
      _firestore.collection('users').doc(uid).collection('weightEntries');

  @override
  Stream<List<WaterEntry>> watchWaterEntries(String uid) => _waterEntries(uid)
      .orderBy('loggedAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map(WaterEntry.fromDocument).toList());

  @override
  Future<void> addWaterEntry(String uid, WaterEntry entry) =>
      _waterEntries(uid).add(entry.toMap());

  @override
  Stream<List<WeightEntry>> watchWeightEntries(String uid) =>
      _weightEntries(uid)
          .orderBy('loggedAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs.map(WeightEntry.fromDocument).toList(),
          );

  @override
  Future<void> addWeightEntry(String uid, WeightEntry entry) =>
      _weightEntries(uid).add(entry.toMap());
}
