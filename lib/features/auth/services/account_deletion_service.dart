import 'package:cloud_functions/cloud_functions.dart';

abstract interface class AccountDeletionService {
  Future<void> deleteCurrentUsersData();
}

class AccountDeletionException implements Exception {
  const AccountDeletionException(this.message);

  factory AccountDeletionException.fromCallableCode(String code) {
    final message = switch (code) {
      'unauthenticated' => 'Your session has expired. Please sign in again.',
      'permission-denied' =>
        'You do not have permission to delete this account. Please sign in again.',
      'not-found' || 'unavailable' || 'failed-precondition' =>
        'Account deletion is temporarily unavailable. Please try again later.',
      'deadline-exceeded' =>
        'Account deletion timed out. Please check your connection and try again.',
      'internal' || 'unknown' =>
        'We could not delete your account right now. Please try again later.',
      _ => 'We could not delete your account. Please try again.',
    };
    return AccountDeletionException(message);
  }

  final String message;

  @override
  String toString() => message;
}

class AccountDeletionResponse {
  const AccountDeletionResponse._();

  factory AccountDeletionResponse.fromCallableData(Object? data) {
    if (data is Map && data['deleted'] == true) {
      return const AccountDeletionResponse._();
    }
    throw const AccountDeletionException(
      'We could not confirm that your account was deleted. Please try again.',
    );
  }
}

class FirebaseAccountDeletionService implements AccountDeletionService {
  FirebaseAccountDeletionService({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  @override
  Future<void> deleteCurrentUsersData() async {
    try {
      final result = await _functions
          .httpsCallable('deleteAccount')
          .call<Object?>();
      AccountDeletionResponse.fromCallableData(result.data);
    } on FirebaseFunctionsException catch (error) {
      throw AccountDeletionException.fromCallableCode(error.code);
    }
  }
}
