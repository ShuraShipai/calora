import 'package:calora/features/auth/services/account_deletion_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountDeletionResponse', () {
    test('accepts the deleteAccount callable success response', () {
      expect(
        () => AccountDeletionResponse.fromCallableData({'deleted': true}),
        returnsNormally,
      );
    });

    test('rejects a callable response that does not confirm deletion', () {
      expect(
        () => AccountDeletionResponse.fromCallableData({'deleted': false}),
        throwsA(isA<AccountDeletionException>()),
      );
    });

    test('maps an unavailable callable to an actionable message', () {
      expect(
        AccountDeletionException.fromCallableCode('unavailable').message,
        'Account deletion is temporarily unavailable. Please try again later.',
      );
    });

    test('maps an unauthenticated callable to a sign-in message', () {
      expect(
        AccountDeletionException.fromCallableCode('unauthenticated').message,
        'Your session has expired. Please sign in again.',
      );
    });
  });
}
