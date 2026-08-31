import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/bloc_helper.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  late MockTvSeriesDetailBloc mockDetailBloc;
  late MockTvSeriesRecommendationsBloc mockRecommendationsBloc;
  late MockWatchlistTvSeriesStatusBloc mockWatchlistBloc;

  setUp(() {
    setUpWidgetTest();
    mockDetailBloc = MockTvSeriesDetailBloc();
    mockRecommendationsBloc = MockTvSeriesRecommendationsBloc();
    mockWatchlistBloc = MockWatchlistTvSeriesStatusBloc();

    registerFallbackValue(const FetchTvSeriesDetail(1));
    registerFallbackValue(const FetchTvSeriesRecommendations(1));
    registerFallbackValue(const LoadWatchlistTvSeriesStatus(1));
  });

  void stubDetail(TvSeriesDetailState state) {
    whenListen(mockDetailBloc, Stream.value(state), initialState: state);
  }

  void stubRecommendations(TvSeriesListState state) {
    whenListen(
      mockRecommendationsBloc,
      Stream.value(state),
      initialState: state,
    );
  }

  void stubWatchlist(
    WatchlistTvSeriesStatusState state, {
    Stream<WatchlistTvSeriesStatusState>? stream,
  }) {
    whenListen(
      mockWatchlistBloc,
      stream ?? Stream.value(state),
      initialState: state,
    );
  }

  Widget makeTestableWidget(Widget body, {RouteFactory? onGenerateRoute}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesDetailBloc>.value(value: mockDetailBloc),
        BlocProvider<TvSeriesRecommendationsBloc>.value(
          value: mockRecommendationsBloc,
        ),
        BlocProvider<WatchlistTvSeriesStatusBloc>.value(
          value: mockWatchlistBloc,
        ),
      ],
      child: MaterialApp(home: body, onGenerateRoute: onGenerateRoute),
    );
  }

  testWidgets('should display a progress indicator while loading', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailLoading());
    stubRecommendations(const TvSeriesListLoading());
    stubWatchlist(const WatchlistTvSeriesStatusState());

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display the detail content when the data is loaded', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(TvSeriesListHasData(testTvSeriesList));
    stubWatchlist(const WatchlistTvSeriesStatusState());

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byType(TvSeriesDetailContent), findsOneWidget);
    expect(find.text(testTvSeriesDetail.name), findsOneWidget);
  });

  testWidgets('should display an error message when the request fails', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailError('Server Failure'));
    stubRecommendations(const TvSeriesListEmpty());
    stubWatchlist(const WatchlistTvSeriesStatusState());

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display an add icon when the tv series is not saved', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(const TvSeriesListEmpty());
    stubWatchlist(const WatchlistTvSeriesStatusState());

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('should display a check icon when the tv series is saved', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(const TvSeriesListEmpty());
    stubWatchlist(const WatchlistTvSeriesStatusState(isAddedToWatchlist: true));

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('should send the add event when the watchlist button is tapped', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(const TvSeriesListEmpty());
    stubWatchlist(const WatchlistTvSeriesStatusState());

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('watchlist_button')));
    await tester.pump();

    verify(
      () => mockWatchlistBloc.add(
        const AddTvSeriesToWatchlist(testTvSeriesDetail),
      ),
    ).called(1);
  });

  testWidgets(
    'should send the remove event when the tv series is already saved',
    (tester) async {
      stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
      stubRecommendations(const TvSeriesListEmpty());
      stubWatchlist(
        const WatchlistTvSeriesStatusState(isAddedToWatchlist: true),
      );

      await tester.pumpWidget(
        makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('watchlist_button')));
      await tester.pump();

      verify(
        () => mockWatchlistBloc.add(
          const RemoveTvSeriesFromWatchlist(testTvSeriesDetail),
        ),
      ).called(1);
    },
  );

  testWidgets('should show a snackbar after the tv series is saved', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(const TvSeriesListEmpty());
    stubWatchlist(
      const WatchlistTvSeriesStatusState(),
      stream: Stream.fromIterable([
        const WatchlistTvSeriesStatusState(),
        const WatchlistTvSeriesStatusState(
          isAddedToWatchlist: true,
          message: WatchlistTvSeriesStatusBloc.watchlistAddSuccessMessage,
        ),
      ]),
    );

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('should show a dialog when saving the tv series fails', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(const TvSeriesListEmpty());
    stubWatchlist(
      const WatchlistTvSeriesStatusState(),
      stream: Stream.fromIterable([
        const WatchlistTvSeriesStatusState(),
        const WatchlistTvSeriesStatusState(message: 'Failed'),
      ]),
    );

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('should display the season list and open the season detail', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(const TvSeriesListEmpty());
    stubWatchlist(const WatchlistTvSeriesStatusState());
    var routeName = '';

    await tester.pumpWidget(
      makeTestableWidget(
        const TvSeriesDetailPage(id: 1),
        onGenerateRoute: (settings) {
          routeName = settings.name ?? '';
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('page')),
          );
        },
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('season_list')), findsOneWidget);

    // Daftar season berada di bawah lipatan pada viewport 800x600 sehingga
    // perlu digulirkan lebih dahulu sebelum dapat ditekan.
    await tester.ensureVisible(find.byKey(const Key('season_card_1')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('season_card_1')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(routeName, AppRoutes.seasonDetail);
  });

  testWidgets('should display the recommendation list when it is loaded', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(TvSeriesListHasData(testTvSeriesList));
    stubWatchlist(const WatchlistTvSeriesStatusState());

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(
      find.byKey(Key('recommendation_${testTvSeries.id}')),
      findsOneWidget,
    );
  });

  testWidgets('should display an error text when recommendations fail', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(const TvSeriesListError('Failed to load'));
    stubWatchlist(const WatchlistTvSeriesStatusState());

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.text('Failed to load'), findsOneWidget);
  });

  testWidgets('should display nothing before the detail is requested', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailEmpty());
    stubRecommendations(const TvSeriesListEmpty());
    stubWatchlist(const WatchlistTvSeriesStatusState());

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );

    expect(find.byType(TvSeriesDetailContent), findsNothing);
  });

  testWidgets('should pop the page when the back button is tapped', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(const TvSeriesListEmpty());
    stubWatchlist(const WatchlistTvSeriesStatusState());

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<TvSeriesDetailBloc>.value(value: mockDetailBloc),
          BlocProvider<TvSeriesRecommendationsBloc>.value(
            value: mockRecommendationsBloc,
          ),
          BlocProvider<WatchlistTvSeriesStatusBloc>.value(
            value: mockWatchlistBloc,
          ),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => TvSeriesDetailPage(key: UniqueKey(), id: 1),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(TvSeriesDetailPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(TvSeriesDetailPage), findsNothing);
  });

  testWidgets('should open another tv series from the recommendation list', (
    tester,
  ) async {
    stubDetail(const TvSeriesDetailHasData(testTvSeriesDetail));
    stubRecommendations(TvSeriesListHasData(testTvSeriesList));
    stubWatchlist(const WatchlistTvSeriesStatusState());
    var routeName = '';

    await tester.pumpWidget(
      makeTestableWidget(
        TvSeriesDetailPage(key: UniqueKey(), id: 1),
        onGenerateRoute: (settings) {
          routeName = settings.name ?? '';
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('page')),
          );
        },
      ),
    );
    await tester.pump();

    final recommendation = find.byKey(Key('recommendation_${testTvSeries.id}'));
    await tester.ensureVisible(recommendation);
    await tester.pump();
    await tester.tap(recommendation);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(routeName, AppRoutes.tvSeriesDetail);
  });

  testWidgets('should describe a tv series without seasons and runtime', (
    tester,
  ) async {
    const bareTvSeries = TvSeriesDetail(
      backdropPath: '/path.jpg',
      episodeRunTime: [],
      firstAirDate: '2020-05-05',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      name: 'Name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      originalName: 'Original Name',
      overview: '',
      posterPath: '/path.jpg',
      seasons: [],
      status: 'Returning Series',
      voteAverage: 1.0,
      voteCount: 1,
    );
    stubDetail(const TvSeriesDetailHasData(bareTvSeries));
    stubRecommendations(const TvSeriesListEmpty());
    stubWatchlist(const WatchlistTvSeriesStatusState());

    await tester.pumpWidget(
      makeTestableWidget(TvSeriesDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.text('Durasi tidak diketahui'), findsOneWidget);
    expect(find.text('Tidak ada informasi season.'), findsOneWidget);
    expect(find.text('Tidak ada sinopsis untuk serial ini.'), findsOneWidget);
  });
}
