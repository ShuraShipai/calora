import 'package:calora/features/home/models/home_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class HomeDashboardService {
  Stream<HomeDashboard> watchToday({
    required String uid,
    required int calorieGoal,
  });
}

class FirestoreHomeDashboardService implements HomeDashboardService {
  FirestoreHomeDashboardService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Stream<HomeDashboard> watchToday({
    required String uid,
    required int calorieGoal,
  }) {
    final today = DateTime.now();
    final documentId =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('dailySummaries')
        .doc(documentId)
        .snapshots()
        .map(
          (snapshot) => snapshot.exists
              ? HomeDashboard.fromMap(
                  snapshot.data()!,
                  calorieGoal: calorieGoal,
                )
              : HomeDashboard.empty(calorieGoal: calorieGoal),
        );
  }
}
