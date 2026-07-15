import 'package:cloud_firestore/cloud_firestore.dart';

class WaterEntry {
  const WaterEntry({
    required this.id,
    required this.amountMl,
    required this.loggedAt,
  });

  factory WaterEntry.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return WaterEntry(
      id: doc.id,
      amountMl: (data['amountMl'] as num?)?.toInt() ?? 0,
      loggedAt: (data['loggedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  final String id;
  final int amountMl;
  final DateTime loggedAt;

  Map<String, Object> toMap() => <String, Object>{
    'amountMl': amountMl,
    'loggedAt': Timestamp.fromDate(loggedAt),
  };
}
