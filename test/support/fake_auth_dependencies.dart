import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/auth/services/auth_service.dart';
import 'package:calora/features/auth/services/user_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FakeAuthService implements AuthService {
  @override
  Stream<User?> authStateChanges() => Stream<User?>.value(null);

  @override
  User? get currentUser => null;

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> reauthenticateWithPassword(String password) async {}

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  @override
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<void> signOut() async {}

  @override
  Future<void> deleteAccount() async {}
}

class FakeUserProfileService implements UserProfileService {
  @override
  Future<UserProfile> completeOnboarding({
    required UserProfile profile,
    required String name,
    required OnboardingDetails details,
  }) async {
    return profile.copyWith(
      name: name,
      onboardingComplete: true,
      onboarding: details,
    );
  }

  @override
  Future<UserProfile> updateProfile({
    required UserProfile profile,
    required String name,
    required OnboardingDetails details,
  }) async => profile.copyWith(name: name, onboarding: details);

  @override
  Future<UserProfile> ensureProfile(User user, {String? name}) =>
      throw UnimplementedError();

  @override
  Future<UserProfile?> fetch(String uid) async => null;

  @override
  Future<void> delete(String uid) async {}
}
