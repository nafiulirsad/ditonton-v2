import 'package:core/core.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/widget_test_helper.dart';

/// Pelapor eror sederhana untuk memverifikasi tombol uji Crashlytics.
class _FakeCrashReporter implements CrashReporter {
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
  setUp(setUpWidgetTest);

  testWidgets('should display the application description', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));

    expect(find.byType(Image), findsOneWidget);
    expect(find.textContaining('Ditonton merupakan'), findsOneWidget);
  });

  testWidgets('should hide the crash test buttons without a reporter', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));

    expect(find.byKey(const Key('record_error_button')), findsNothing);
    expect(find.byKey(const Key('force_crash_button')), findsNothing);
  });

  testWidgets('should send a non fatal error to the reporter', (tester) async {
    final reporter = _FakeCrashReporter();

    await tester.pumpWidget(
      MaterialApp(home: AboutPage(crashReporter: reporter)),
    );

    await tester.tap(find.byKey(const Key('record_error_button')));
    await tester.pump();

    expect(reporter.errors, hasLength(1));
    expect(find.text('Eror uji terkirim ke Crashlytics'), findsOneWidget);
  });

  testWidgets('should force a crash through the reporter', (tester) async {
    final reporter = _FakeCrashReporter();

    await tester.pumpWidget(
      MaterialApp(home: AboutPage(crashReporter: reporter)),
    );

    await tester.tap(find.byKey(const Key('force_crash_button')));
    await tester.pump();

    expect(reporter.crashed, isTrue);
  });

  testWidgets('should pop the page when the back button is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const AboutPage()),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(AboutPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(AboutPage), findsNothing);
  });
}
