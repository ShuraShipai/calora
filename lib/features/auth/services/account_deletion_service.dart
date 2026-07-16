import 'package:cloud_functions/cloud_functions.dart';

abstract interface class AccountDeletionService {
  Future<void> deleteCurrentUsersData();
}

class FirebaseAccountDeletionService implements AccountDeletionService {
  FirebaseAccountDeletionService({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  @override
  Future<void> deleteCurrentUsersData() async {
    await _functions.httpsCallable('deleteAccount').call<void>();
  }
}
