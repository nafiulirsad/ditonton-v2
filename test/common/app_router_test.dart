import 'package:core/core.dart';
import 'package:ditonton/common/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

void main() {
  const seasonArgs = SeasonDetailArgs(
    tvSeriesId: 1,
    seasonNumber: 1,
    seasonName: 'Season 1',
  );

  final materialRoutes = <String, Object?>{
    AppRoutes.homeMovie: null,
    AppRoutes.homeTvSeries: null,
    AppRoutes.movieDetail: 1,
    AppRoutes.tvSeriesDetail: 1,
    AppRoutes.seasonDetail: seasonArgs,
    AppRoutes.watchlist: null,
    AppRoutes.about: null,
  };

  final cupertinoRoutes = <String>[
    AppRoutes.popularMovies,
    AppRoutes.topRatedMovies,
    AppRoutes.searchMovies,
    AppRoutes.onTheAirTvSeries,
    AppRoutes.popularTvSeries,
    AppRoutes.topRatedTvSeries,
    AppRoutes.searchTvSeries,
  ];

  test('should build a MaterialPageRoute for every material route', () {
    materialRoutes.forEach((name, arguments) {
      final route = generateRoute(
        RouteSettings(name: name, arguments: arguments),
      );
      expect(route, isA<MaterialPageRoute<dynamic>>(), reason: name);
    });
  });

  test('should build a CupertinoPageRoute for every cupertino route', () {
    for (final name in cupertinoRoutes) {
      final route = generateRoute(RouteSettings(name: name));
      expect(route, isA<CupertinoPageRoute<dynamic>>(), reason: name);
    }
  });

  testWidgets('should build a not found page for an unknown route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: generateRoute,
        initialRoute: '/unknown-route',
      ),
    );

    expect(find.byKey(const Key('page_not_found')), findsOneWidget);
    expect(find.text('Page not found :('), findsOneWidget);
  });
}
