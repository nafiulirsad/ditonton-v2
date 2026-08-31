import 'package:core/core.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/main.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:movie/movie.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tv_series/tv_series.dart';

import 'helpers/widget_test_helper.dart';

/// Pelapor palsu supaya pengujian tidak membutuhkan Firebase.
class _FakeAnalyticsReporter implements AnalyticsReporter {
  @override
  Future<void> logScreenView(String screenName) async {}

  @override
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {}
}

class _FakeCrashReporter implements CrashReporter {
  @override
  Future<void> recordError(Object error, StackTrace? stackTrace) async {}

  @override
  void forceCrash() {}
}

void main() {
  setUp(() async {
    setUpWidgetTest();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    await di.init(
      // Seluruh permintaan dijawab dengan galat supaya pengujian tidak
      // bergantung pada jaringan maupun bentuk payload TMDB.
      httpClient: MockClient((request) async => http.Response('{}', 500)),
      analyticsReporter: _FakeAnalyticsReporter(),
      crashReporter: _FakeCrashReporter(),
    );
  });

  tearDown(() => di.locator.reset());

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
  }

  Future<void> pushRoute(
    WidgetTester tester,
    String routeName, {
    Object? arguments,
  }) async {
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.pushNamed<void>(routeName, arguments: arguments);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> popRoute(WidgetTester tester) async {
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.pop();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('should start on the movie home page', (tester) async {
    await pumpApp(tester);

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(HomeMoviePage), findsOneWidget);
  });

  testWidgets('should open every movie route', (tester) async {
    await pumpApp(tester);

    await pushRoute(tester, AppRoutes.popularMovies);
    expect(find.byType(PopularMoviesPage), findsOneWidget);
    await popRoute(tester);

    await pushRoute(tester, AppRoutes.topRatedMovies);
    expect(find.byType(TopRatedMoviesPage), findsOneWidget);
    await popRoute(tester);

    await pushRoute(tester, AppRoutes.searchMovies);
    expect(find.byType(SearchPage), findsOneWidget);
    await popRoute(tester);

    await pushRoute(tester, AppRoutes.movieDetail, arguments: 1);
    expect(find.byType(MovieDetailPage), findsOneWidget);
  });

  testWidgets('should open every tv series route', (tester) async {
    await pumpApp(tester);

    await pushRoute(tester, AppRoutes.homeTvSeries);
    expect(find.byType(HomeTvSeriesPage), findsOneWidget);
    await popRoute(tester);

    await pushRoute(tester, AppRoutes.onTheAirTvSeries);
    expect(find.byType(OnTheAirTvSeriesPage), findsOneWidget);
    await popRoute(tester);

    await pushRoute(tester, AppRoutes.popularTvSeries);
    expect(find.byType(PopularTvSeriesPage), findsOneWidget);
    await popRoute(tester);

    await pushRoute(tester, AppRoutes.topRatedTvSeries);
    expect(find.byType(TopRatedTvSeriesPage), findsOneWidget);
    await popRoute(tester);

    await pushRoute(tester, AppRoutes.searchTvSeries);
    expect(find.byType(SearchTvSeriesPage), findsOneWidget);
    await popRoute(tester);

    await pushRoute(tester, AppRoutes.tvSeriesDetail, arguments: 1);
    expect(find.byType(TvSeriesDetailPage), findsOneWidget);
    await popRoute(tester);

    await pushRoute(
      tester,
      AppRoutes.seasonDetail,
      arguments: const SeasonDetailArgs(
        tvSeriesId: 1,
        seasonNumber: 1,
        seasonName: 'Season 1',
      ),
    );
    expect(find.byType(SeasonDetailPage), findsOneWidget);
  });

  testWidgets('should open the watchlist and about pages', (tester) async {
    await pumpApp(tester);

    await pushRoute(tester, AppRoutes.watchlist);
    expect(find.byType(WatchlistPage), findsOneWidget);
    await popRoute(tester);

    await pushRoute(tester, AppRoutes.about);
    expect(find.byType(AboutPage), findsOneWidget);
  });
}
