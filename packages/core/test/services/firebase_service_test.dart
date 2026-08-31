import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';

/// Pelapor eror sederhana untuk memverifikasi pemasangan penangkap eror global.
class _RecordingCrashReporter implements CrashReporter {
  final List<Object> errors = [];
  bool crashed = false;

  @override
  Future<void> recordError(Object error, StackTrace? stackTrace) async {
    errors.add(error);
  }

  @override
  void forceCrash() => crashed = true;
}

void main() {
  group('FirebaseAnalyticsReporter', () {
    late MockFirebaseAnalytics mockAnalytics;
    late FirebaseAnalyticsReporter reporter;

    setUp(() {
      mockAnalytics = MockFirebaseAnalytics();
      reporter = FirebaseAnalyticsReporter(analytics: mockAnalytics);
    });

    test('should forward screen views to Firebase Analytics', () async {
      await reporter.logScreenView('/home');

      verify(mockAnalytics.logScreenView(screenName: '/home'));
    });

    test('should forward selected content to Firebase Analytics', () async {
      await reporter.logSelectContent(contentType: 'movie', itemId: '1');

      verify(mockAnalytics.logSelectContent(contentType: 'movie', itemId: '1'));
    });
  });

  group('FirebaseCrashReporter', () {
    late MockFirebaseCrashlytics mockCrashlytics;
    late FirebaseCrashReporter reporter;

    setUp(() {
      mockCrashlytics = MockFirebaseCrashlytics();
      reporter = FirebaseCrashReporter(crashlytics: mockCrashlytics);
    });

    test('should forward errors to Crashlytics', () async {
      final error = Exception('boom');
      final stackTrace = StackTrace.current;

      await reporter.recordError(error, stackTrace);

      verify(mockCrashlytics.recordError(error, stackTrace));
    });

    test('should forward a forced crash to Crashlytics', () {
      reporter.forceCrash();

      verify(mockCrashlytics.crash());
    });
  });

  group('registerCrashHandlers', () {
    late FlutterExceptionHandler? previousFlutterHandler;
    late bool Function(Object, StackTrace)? previousPlatformHandler;

    setUp(() {
      previousFlutterHandler = FlutterError.onError;
      previousPlatformHandler = PlatformDispatcher.instance.onError;
    });

    tearDown(() {
      FlutterError.onError = previousFlutterHandler;
      PlatformDispatcher.instance.onError = previousPlatformHandler;
    });

    test('should report flutter framework errors', () {
      final reporter = _RecordingCrashReporter();
      var previousCalled = false;

      registerCrashHandlers(
        reporter: reporter,
        previousOnError: (_) => previousCalled = true,
      );

      final error = Exception('widget error');
      FlutterError.onError!(
        FlutterErrorDetails(exception: error, stack: StackTrace.current),
      );

      expect(reporter.errors, contains(error));
      expect(previousCalled, isTrue);
    });

    test('should report uncaught platform errors', () {
      final reporter = _RecordingCrashReporter();

      registerCrashHandlers(reporter: reporter);

      final error = Exception('async error');
      final handled = PlatformDispatcher.instance.onError!(
        error,
        StackTrace.current,
      );

      expect(handled, isTrue);
      expect(reporter.errors, contains(error));
    });
  });
}
