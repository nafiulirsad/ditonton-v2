import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/main.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

/// Integration test yang menjalankan aplikasi sesungguhnya pada perangkat.
///
/// Jalankan dengan perintah:
/// `flutter test integration_test/app_test.dart`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => di.init());
  tearDown(() => di.locator.reset());

  Future<void> startApp(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 3));
  }

  Future<void> openDrawer(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('should open the movie home page when the app starts', (
    tester,
  ) async {
    await startApp(tester);

    expect(find.byType(HomeMoviePage), findsOneWidget);
    expect(find.text('Now Playing'), findsOneWidget);
  });

  testWidgets('should move to the tv series page through the drawer', (
    tester,
  ) async {
    await startApp(tester);
    await openDrawer(tester);

    await tester.tap(find.byKey(const Key('drawer_tv_series')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(HomeTvSeriesPage), findsOneWidget);
    expect(find.text('On The Air'), findsOneWidget);
  });

  testWidgets('should search a tv series by its title', (tester) async {
    await startApp(tester);
    await openDrawer(tester);

    await tester.tap(find.byKey(const Key('drawer_tv_series')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    await tester.tap(find.byKey(const Key('search_tv_series_button')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SearchTvSeriesPage), findsOneWidget);

    await tester.enterText(find.byKey(const Key('query_input')), 'The Office');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Search Result'), findsOneWidget);
  });

  testWidgets('should search a movie by its title', (tester) async {
    await startApp(tester);

    await tester.tap(find.byKey(const Key('search_movie_button')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SearchPage), findsOneWidget);

    await tester.enterText(find.byKey(const Key('query_input')), 'Spider-Man');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Search Result'), findsOneWidget);
  });

  testWidgets('should open the watchlist page through the drawer', (
    tester,
  ) async {
    await startApp(tester);
    await openDrawer(tester);

    await tester.tap(find.byKey(const Key('drawer_watchlist')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(WatchlistPage), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
  });
}
