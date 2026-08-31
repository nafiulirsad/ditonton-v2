import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Membangun [http.Client] yang hanya mempercayai sertifikat milik TMDB.
///
/// Sertifikat Amazon Root CA 1 beserta intermediate-nya dibundel pada
/// `assets/certificates/tmdb.pem`. Dengan `withTrustedRoots: false`, daftar
/// certificate authority bawaan sistem diabaikan sehingga koneksi ke host yang
/// memakai sertifikat lain — termasuk proxy penyadap — otomatis ditolak.
abstract final class SslPinningHttpClient {
  /// Lokasi berkas sertifikat pada asset bundle.
  static const String certificateAsset =
      'packages/core/assets/certificates/tmdb.pem';

  /// Membuat klien HTTP dengan SSL pinning aktif.
  ///
  /// [bundle] dapat diisi pada pengujian untuk menghindari akses ke
  /// `rootBundle`.
  static Future<http.Client> create({AssetBundle? bundle}) async {
    final certificate = await (bundle ?? rootBundle).load(certificateAsset);

    final context = SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(certificate.buffer.asUint8List());

    final httpClient = HttpClient(context: context)
      ..badCertificateCallback = badCertificateCallback;

    return IOClient(httpClient);
  }

  /// Menolak seluruh sertifikat yang tidak lolos verifikasi rantai TMDB.
  @visibleForTesting
  static bool badCertificateCallback(
    X509Certificate certificate,
    String host,
    int port,
  ) => false;
}
