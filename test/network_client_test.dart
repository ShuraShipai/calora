import 'dart:typed_data';

import 'package:calora/core/network/network_client.dart';
import 'package:calora/core/network/network_connectivity_service.dart';
import 'package:calora/core/network/network_exception.dart';
import 'package:dio/dio.dart';
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

  test('retries one transient food database response', () async {
    final adapter = _SequenceHttpClientAdapter(<ResponseBody>[
      ResponseBody.fromString(
        '{}',
        503,
        headers: <String, List<String>>{
          Headers.contentTypeHeader: <String>['application/json'],
        },
      ),
      ResponseBody.fromString(
        '{"status": 1}',
        200,
        headers: <String, List<String>>{
          Headers.contentTypeHeader: <String>['application/json'],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = DioNetworkClient(
      connectivity: const _FakeConnectivityService(isConnected: true),
      dio: dio,
    );

    final response = await client.getJson(
      Uri.parse('https://example.com/product'),
    );

    expect(response['status'], 1);
    expect(adapter.requestCount, 2);
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

class _SequenceHttpClientAdapter implements HttpClientAdapter {
  _SequenceHttpClientAdapter(this._responses);

  final List<ResponseBody> _responses;
  var requestCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount += 1;
    return _responses.removeAt(0);
  }

  @override
  void close({bool force = false}) {}
}
