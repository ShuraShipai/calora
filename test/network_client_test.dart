import 'package:calora/core/network/network_client.dart';
import 'package:calora/core/network/network_connectivity_service.dart';
import 'package:calora/core/network/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fails before a request when the device is offline', () async {
    final client = DioNetworkClient(
      connectivity: _FakeConnectivityService(isConnected: false),
    );

    expect(
      () => client.getJson(Uri.parse('https://example.com/product')),
      throwsA(
        isA<NetworkException>().having(
          (error) => error.kind,
          'kind',
          NetworkExceptionKind.offline,
        ),
      ),
    );
  });
}

class _FakeConnectivityService implements NetworkConnectivityService {
  const _FakeConnectivityService({required bool isConnected})
    : this._(isConnected);

  const _FakeConnectivityService._(this._isConnected);

  final bool _isConnected;

  @override
  Future<bool> get isConnected async => _isConnected;
}
