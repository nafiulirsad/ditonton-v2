import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';

/// Sertifikat palsu untuk menguji callback penolakan.
class _FakeX509Certificate implements X509Certificate {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Asset bundle palsu supaya pengujian tidak bergantung pada `rootBundle`.
class _FakeAssetBundle extends CachingAssetBundle {
  final Uint8List certificate;

  _FakeAssetBundle(this.certificate);

  @override
  Future<ByteData> load(String key) async {
    expect(key, SslPinningHttpClient.certificateAsset);
    return ByteData.view(certificate.buffer);
  }
}

void main() {
  late HttpOverrides? previousHttpOverrides;
  late Uint8List tmdbCertificate;
  late HttpServer server;
  late Uri serverUri;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // `flutter_test` memasang HttpOverrides yang mengembalikan respons palsu.
    // Pengujian SSL pinning membutuhkan HttpClient asli.
    previousHttpOverrides = HttpOverrides.current;
    HttpOverrides.global = null;

    tmdbCertificate = File('assets/certificates/tmdb.pem').readAsBytesSync();

    final context = SecurityContext()
      ..useCertificateChain('test/fixtures/server_cert.pem')
      ..usePrivateKey('test/fixtures/server_key.pem');

    server = await HttpServer.bindSecure(
      InternetAddress.loopbackIPv4,
      0,
      context,
    );
    serverUri = Uri.parse('https://localhost:${server.port}/');

    server.listen((request) async {
      request.response.write('ok');
      await request.response.close();
    });
  });

  tearDownAll(() async {
    HttpOverrides.global = previousHttpOverrides;
    await server.close(force: true);
  });

  test('should build an http client backed by dart:io', () async {
    final client = await SslPinningHttpClient.create(
      bundle: _FakeAssetBundle(tmdbCertificate),
    );

    expect(client, isA<IOClient>());
    client.close();
  });

  test(
    'should reject a host that is not signed by the pinned authority',
    () async {
      final client = await SslPinningHttpClient.create(
        bundle: _FakeAssetBundle(tmdbCertificate),
      );

      await expectLater(
        client.get(serverUri),
        throwsA(isA<HandshakeException>()),
      );

      client.close();
    },
  );

  test('should refuse every certificate that fails verification', () {
    expect(
      SslPinningHttpClient.badCertificateCallback(
        _FakeX509Certificate(),
        'localhost',
        443,
      ),
      isFalse,
    );
  });
}
