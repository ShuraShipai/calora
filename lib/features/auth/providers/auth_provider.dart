import 'dart:async';

import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/auth/services/auth_service.dart';
import 'package:calora/features/auth/services/account_deletion_service.dart';
import 'package:calora/features/auth/services/user_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus {
  initializing,
  unauthenticated,
  requiresOnboarding,
  authenticated,
}

class AuthProvider extends ChangeNotifier {
  AuthProvider(
    this._authService,
    this._profileService, {
    AccountDeletionService? accountDeletionService,
  }) : _accountDeletionService =
           accountDeletionService ?? _UnavailableAccountDeletionService() {
    _subscription = _authService.authStateChanges().listen(_handleAuthChange);
  }

  final AuthService _authService;
  final UserProfileService _profileService;
  final AccountDeletionService _accountDeletionService;
  late final StreamSubscription<User?> _subscription;

  AuthStatus _status = AuthStatus.initializing;
  UserProfile? _profile;
  bool _isBusy = false;
  String? _errorMessage;
  int _syncVersion = 0;

  AuthStatus get status => _status;
  UserProfile? get profile => _profile;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn({required String email, required String password}) {
    return _runCredentialTask(
      () => _authService.signIn(email: email, password: password),
    );
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _runCredentialTask(
      () => _authService.signUp(name: name, email: email, password: password),
      requestedName: name,
    );
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    return _runTask(() => _authService.sendPasswordResetEmail(email));
  }

  Future<bool> completeOnboarding({
    required String name,
    required OnboardingDetails details,
  }) async {
    final current = _profile;
    if (current == null) {
      _setError('Your session has expired. Please sign in again.');
      return false;
    }
    return _runTask(() async {
      _profile = await _profileService.completeOnboarding(
        profile: current,
        name: name,
        details: details,
      );
      _status = AuthStatus.authenticated;
    });
  }

  Future<bool> updateProfile({
    required String name,
    required OnboardingDetails details,
  }) async {
    final current = _profile;
    if (current == null) {
      _setError('Your session has expired. Please sign in again.');
      return false;
    }
    return _runTask(() async {
      _profile = await _profileService.updateProfile(
        profile: current,
        name: name,
        details: details,
      );
    });
  }

  Future<void> signOut() async {
    _setBusy(true);
    try {
      await _authService.signOut();
      _profile = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
    } on FirebaseException catch (error) {
      _errorMessage = _messageFor(error.code);
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> deleteAccount({required String password}) async {
    final profile = _profile;
    if (profile == null) {
      _setError('Your session has expired. Please sign in again.');
      return false;
    }
    return _runTask(() async {
      await _authService.reauthenticateWithPassword(password);
      await _accountDeletionService.deleteCurrentUsersData();
      _profile = null;
      _status = AuthStatus.unauthenticated;
    });
  }

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _runCredentialTask(
    Future<UserCredential> Function() action, {
    String? requestedName,
  }) async {
    return _runTask(() async {
      final credential = await action();
      final user = credential.user;
      if (user == null) throw StateError('Firebase returned no user.');
      await _resolveUser(user, requestedName: requestedName);
    });
  }

  Future<bool> _runTask(Future<void> Function() action) async {
    _errorMessage = null;
    _setBusy(true);
    try {
      await action();
      return true;
    } on FirebaseException catch (error) {
      _errorMessage = _messageFor(error.code);
      return false;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> _handleAuthChange(User? user) async {
    final version = ++_syncVersion;
    if (user == null) {
      _profile = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }
    _profile = null;
    _status = AuthStatus.initializing;
    notifyListeners();
    try {
      await _resolveUser(user, version: version);
    } on FirebaseException catch (error) {
      if (version != _syncVersion) return;
      _errorMessage = _messageFor(error.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> _resolveUser(
    User user, {
    String? requestedName,
    int? version,
  }) async {
    final profile = await _profileService.ensureProfile(
      user,
      name: requestedName,
    );
    if (version != null && version != _syncVersion) return;
    _profile = profile;
    _status = profile.onboardingComplete
        ? AuthStatus.authenticated
        : AuthStatus.requiresOnboarding;
    notifyListeners();
  }

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void _setError(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  String _messageFor(String code) {
    return switch (code) {
      'invalid-email' => 'Enter a valid email address.',
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' => 'Email or password is incorrect.',
      'email-already-in-use' => 'An account already exists for this email.',
      'weak-password' => 'Use a password with at least 6 characters.',
      'too-many-requests' => 'Too many attempts. Please try again later.',
      'network-request-failed' ||
      'unavailable' => 'Check your internet connection and try again.',
      'permission-denied' =>
        'We could not save your profile. Please try again.',
      'requires-recent-login' =>
        'Please sign in again before deleting your account.',
      _ => 'Something went wrong. Please try again.',
    };
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

class _UnavailableAccountDeletionService implements AccountDeletionService {
  @override
  Future<void> deleteCurrentUsersData() =>
      Future<void>.error(StateError('Account deletion is unavailable.'));
}
