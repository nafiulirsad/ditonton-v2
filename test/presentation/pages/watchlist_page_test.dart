import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

import '../../helpers/bloc_helper.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  late MockWatchlistMoviesBloc mockMovieBloc;
  late MockWatchlistTvSeriesBloc mockTvSeriesBloc;

  setUp(() {
    setUpWidgetTest();
    mockMovieBloc = MockWatchlistMoviesBloc();
    mockTvSeriesBloc = MockWatchlistTvSeriesBloc();

    whenListen(
      mockMovieBloc,
      Stream.value(const MovieListHasData([])),
      initialState: const MovieListHasData([]),
    );
    whenListen(
      mockTvSeriesBloc,
      Stream.value(const TvSeriesListHasData([])),
      initialState: const TvSeriesListHasData([]),
    );
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<WatchlistMoviesBloc>.value(value: mockMovieBloc),
          BlocProvider<WatchlistTvSeriesBloc>.value(value: mockTvSeriesBloc),
        ],
        child: const MaterialApp(home: WatchlistPage()),
      ),
    );
    await tester.pump();
  }

  testWidgets('should display both watchlist tabs', (tester) async {
    await pumpPage(tester);

    expect(find.byKey(const Key('watchlist_movie_tab')), findsOneWidget);
    expect(find.byKey(const Key('watchlist_tv_series_tab')), findsOneWidget);
    expect(find.byType(WatchlistMoviesPage), findsOneWidget);
  });

  testWidgets('should open the tv series tab when it is tapped', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.byKey(const Key('watchlist_tv_series_tab')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(WatchlistTvSeriesPage), findsOneWidget);
  });
}
