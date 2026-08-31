import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

final locator = GetIt.instance;

/// Mendaftarkan dependensi milik modul core lalu meneruskannya ke tiap modul
/// fitur.
///
/// [httpClient], [analyticsReporter], dan [crashReporter] dapat diisi pada
/// pengujian agar tidak perlu membaca sertifikat SSL dari asset bundle maupun
/// menyalakan Firebase.
Future<void> init({
  http.Client? httpClient,
  AnalyticsReporter? analyticsReporter,
  CrashReporter? crashReporter,
}) async {
  // external
  locator.registerLazySingleton<http.Client>(() => httpClient ?? http.Client());
  if (httpClient == null) {
    // Klien produksi memakai SSL pinning sehingga hanya sertifikat TMDB yang
    // dipercaya.
    final pinnedClient = await SslPinningHttpClient.create();
    locator.unregister<http.Client>();
    locator.registerLazySingleton<http.Client>(() => pinnedClient);
  }

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // layanan Firebase
  locator.registerLazySingleton<AnalyticsReporter>(
    () =>
        analyticsReporter ??
        FirebaseAnalyticsReporter(analytics: FirebaseAnalytics.instance),
  );
  locator.registerLazySingleton<CrashReporter>(
    () =>
        crashReporter ??
        FirebaseCrashReporter(crashlytics: FirebaseCrashlytics.instance),
  );

  // modul fitur
  registerMovieDependencies(locator);
  registerTvSeriesDependencies(locator);
}
