import 'package:connectivity_plus/connectivity_plus.dart';

/// Reports whether the device has an active network transport.
///
/// A transport connection is not a guarantee that an API is reachable, so the
/// network client still maps request-level connection errors separately.
abstract interface class NetworkConnectivityService {
  Future<bool> get isConnected;
}

class ConnectivityPlusNetworkConnectivityService
    implements NetworkConnectivityService {
  ConnectivityPlusNetworkConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
