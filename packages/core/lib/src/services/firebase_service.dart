import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Kontrak pelaporan peristiwa pemakaian aplikasi.
abstract class AnalyticsReporter {
  /// Mencatat perpindahan halaman.
  Future<void> logScreenView(String screenName);

  /// Mencatat konten yang dibuka pengguna, misalnya detail film.
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  });
}

/// Kontrak pelaporan eror ke layanan pemantauan stabilitas.
abstract class CrashReporter {
  /// Mengirim eror non-fatal beserta stack trace-nya.
  Future<void> recordError(Object error, StackTrace? stackTrace);

  /// Memaksa aplikasi crash. Dipakai untuk memverifikasi integrasi Crashlytics.
  void forceCrash();
}

/// Implementasi [AnalyticsReporter] di atas Firebase Analytics.
class FirebaseAnalyticsReporter implements AnalyticsReporter {
  final FirebaseAnalytics analytics;

  const FirebaseAnalyticsReporter({required this.analytics});

  @override
  Future<void> logScreenView(String screenName) =>
      analytics.logScreenView(screenName: screenName);

  @override
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) => analytics.logSelectContent(contentType: contentType, itemId: itemId);
}

/// Implementasi [CrashReporter] di atas Firebase Crashlytics.
class FirebaseCrashReporter implements CrashReporter {
  final FirebaseCrashlytics crashlytics;

  const FirebaseCrashReporter({required this.crashlytics});

  @override
  Future<void> recordError(Object error, StackTrace? stackTrace) =>
      crashlytics.recordError(error, stackTrace);

  @override
  void forceCrash() => crashlytics.crash();
}

/// Menyambungkan penangkap eror Flutter dan Dart ke [CrashReporter].
///
/// Dipanggil sekali saat aplikasi dijalankan sehingga eror yang tidak tertangani
/// tetap terkirim ke Crashlytics.
void registerCrashHandlers({
  required CrashReporter reporter,
  FlutterExceptionHandler? previousOnError,
}) {
  FlutterError.onError = (details) {
    previousOnError?.call(details);
    reporter.recordError(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    reporter.recordError(error, stackTrace);
    return true;
  };
}
