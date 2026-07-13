import 'package:calora/core/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class UserProfileService {
  Future<UserProfile?> fetch(String uid);
  Future<UserProfile> ensureProfile(User user, {String? name});
  Future<UserProfile> completeOnboarding({
    required UserProfile profile,
    required String name,
    required OnboardingDetails details,
  });
}

class FirestoreUserProfileService implements UserProfileService {
  FirestoreUserProfileService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Future<UserProfile?> fetch(String uid) async {
    final snapshot = await _users.doc(uid).get();
    final data = snapshot.data();
    return data == null ? null : UserProfile.fromMap(snapshot.id, data);
  }

  @override
  Future<UserProfile> ensureProfile(User user, {String? name}) async {
    final existing = await fetch(user.uid);
    if (existing != null) {
      final resolvedName = _resolvedName(user, name);
      if (resolvedName.isNotEmpty && resolvedName != existing.name) {
        await _users.doc(user.uid).update(<String, Object?>{
          'name': resolvedName,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return existing.copyWith(name: resolvedName);
      }
      return existing;
    }

    final resolvedName = _resolvedName(user, name);
    final data = <String, Object?>{
      'name': resolvedName,
      'email': user.email,
      'isAnonymous': user.isAnonymous,
      'onboardingComplete': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _users.doc(user.uid).set(data);
    return UserProfile(
      uid: user.uid,
      email: user.email,
      name: resolvedName,
      isAnonymous: user.isAnonymous,
      onboardingComplete: false,
    );
  }

  @override
  Future<UserProfile> completeOnboarding({
    required UserProfile profile,
    required String name,
    required OnboardingDetails details,
  }) async {
    final resolvedName = name.trim().isEmpty ? profile.name : name.trim();
    await _users.doc(profile.uid).set(<String, Object?>{
      'name': resolvedName,
      ...details.toMap(),
      'onboardingComplete': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return profile.copyWith(
      name: resolvedName,
      onboardingComplete: true,
      onboarding: details,
    );
  }

  String _resolvedName(User user, String? requestedName) {
    final explicit = requestedName?.trim();
    if (explicit != null && explicit.isNotEmpty) return explicit;
    final displayName = user.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) return displayName;
    return '';
  }
}
