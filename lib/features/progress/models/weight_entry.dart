import 'package:cloud_firestore/cloud_firestore.dart';

class WeightEntry {
  const WeightEntry({
    required this.id,
    required this.weightKg,
    required this.loggedAt,
    this.note,
  });

  factory WeightEntry.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return WeightEntry(
      id: doc.id,
      weightKg: (data['weightKg'] as num?)?.toDouble() ?? 0,
      loggedAt: (data['loggedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      note: (data['note'] as String?)?.trim(),
    );
  }

  final String id;
  final double weightKg;
  final DateTime loggedAt;
  final String? note;

  Map<String, Object> toMap() => <String, Object>{
    'weightKg': weightKg,
    'loggedAt': Timestamp.fromDate(loggedAt),
    if (note != null && note!.isNotEmpty) 'note': note!,
  };
}
