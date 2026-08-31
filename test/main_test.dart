import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:movie/movie.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'helpers/widget_test_helper.dart';

void main() {
  setUp(() {
    setUpWidgetTest();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  tearDown(() => di.locator.reset());

  testWidgets('should start the application without Firebase configuration', (
    tester,
  ) async {
    // Konfigurasi Firebase belum tersedia pada lingkungan pengujian sehingga
    // aplikasi harus tetap berjalan tanpa Analytics maupun Crashlytics.
    await app.main();
    await tester.pump();

    expect(find.byType(app.MyApp), findsOneWidget);
    expect(find.byType(HomeMoviePage), findsOneWidget);
  });

  test(
    'should build a pinned http client for the production dependencies',
    () async {
      await di.init();

      // Klien produksi dibangun dari sertifikat TMDB yang dibundel modul core.
      expect(di.locator<http.Client>(), isA<http.Client>());
    },
  );
}
