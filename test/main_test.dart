import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:movie/movie.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'helpers/widget_test_helper.dart';

/// Kanal Pigeon milik `firebase_core`.
///
/// Pada pengujian, kanal ini dijawab `null` sehingga `Firebase.initializeApp`
/// gagal seperti pada perangkat tanpa konfigurasi Firebase.
const _firebaseCoreChannels = <String>[
  'dev.flutter.pigeon.firebase_core_platform_interface.FirebaseCoreHostApi.initializeCore',
  'dev.flutter.pigeon.firebase_core_platform_interface.FirebaseCoreHostApi.initializeApp',
  'dev.flutter.pigeon.firebase_core_platform_interface.FirebaseCoreHostApi.optionsFromResource',
];

void main() {
  setUp(() {
    setUpWidgetTest();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    for (final channel in _firebaseCoreChannels) {
      messenger.setMockMessageHandler(channel, (message) async => null);
    }
  });

  tearDown(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    for (final channel in _firebaseCoreChannels) {
      messenger.setMockMessageHandler(channel, null);
    }
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
