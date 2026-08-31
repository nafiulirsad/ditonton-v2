import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/bloc_helper.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  late MockMovieDetailBloc mockDetailBloc;
  late MockMovieRecommendationsBloc mockRecommendationsBloc;
  late MockWatchlistMovieStatusBloc mockWatchlistBloc;

  setUp(() {
    setUpWidgetTest();
    mockDetailBloc = MockMovieDetailBloc();
    mockRecommendationsBloc = MockMovieRecommendationsBloc();
    mockWatchlistBloc = MockWatchlistMovieStatusBloc();

    registerFallbackValue(const FetchMovieDetail(1));
    registerFallbackValue(const FetchMovieRecommendations(1));
    registerFallbackValue(const LoadWatchlistMovieStatus(1));
  });

  void stubDetail(MovieDetailState state) {
    whenListen(mockDetailBloc, Stream.value(state), initialState: state);
  }

  void stubRecommendations(MovieListState state) {
    whenListen(
      mockRecommendationsBloc,
      Stream.value(state),
      initialState: state,
    );
  }

  void stubWatchlist(
    WatchlistMovieStatusState state, {
    Stream<WatchlistMovieStatusState>? stream,
  }) {
    whenListen(
      mockWatchlistBloc,
      stream ?? Stream.value(state),
      initialState: state,
    );
  }

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockDetailBloc),
        BlocProvider<MovieRecommendationsBloc>.value(
          value: mockRecommendationsBloc,
        ),
        BlocProvider<WatchlistMovieStatusBloc>.value(value: mockWatchlistBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display a progress indicator while loading', (
    tester,
  ) async {
    stubDetail(const MovieDetailLoading());
    stubRecommendations(const MovieListLoading());
    stubWatchlist(const WatchlistMovieStatusState());

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display the detail content when the data is loaded', (
    tester,
  ) async {
    stubDetail(const MovieDetailHasData(testMovieDetail));
    stubRecommendations(MovieListHasData(testMovieList));
    stubWatchlist(const WatchlistMovieStatusState());

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byType(DetailContent), findsOneWidget);
    expect(find.text(testMovieDetail.title), findsOneWidget);
  });

  testWidgets('should display an error message when the request fails', (
    tester,
  ) async {
    stubDetail(const MovieDetailError('Server Failure'));
    stubRecommendations(const MovieListEmpty());
    stubWatchlist(const WatchlistMovieStatusState());

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display an add icon when the movie is not saved', (
    tester,
  ) async {
    stubDetail(const MovieDetailHasData(testMovieDetail));
    stubRecommendations(const MovieListEmpty());
    stubWatchlist(const WatchlistMovieStatusState());

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('should display a check icon when the movie is already saved', (
    tester,
  ) async {
    stubDetail(const MovieDetailHasData(testMovieDetail));
    stubRecommendations(const MovieListEmpty());
    stubWatchlist(const WatchlistMovieStatusState(isAddedToWatchlist: true));

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('should send the add event when the watchlist button is tapped', (
    tester,
  ) async {
    stubDetail(const MovieDetailHasData(testMovieDetail));
    stubRecommendations(const MovieListEmpty());
    stubWatchlist(const WatchlistMovieStatusState());

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('watchlist_button')));
    await tester.pump();

    verify(
      () => mockWatchlistBloc.add(const AddMovieToWatchlist(testMovieDetail)),
    ).called(1);
  });

  testWidgets(
    'should send the remove event when the movie is already on the watchlist',
    (tester) async {
      stubDetail(const MovieDetailHasData(testMovieDetail));
      stubRecommendations(const MovieListEmpty());
      stubWatchlist(const WatchlistMovieStatusState(isAddedToWatchlist: true));

      await tester.pumpWidget(
        makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('watchlist_button')));
      await tester.pump();

      verify(
        () => mockWatchlistBloc.add(
          const RemoveMovieFromWatchlist(testMovieDetail),
        ),
      ).called(1);
    },
  );

  testWidgets('should show a snackbar after the movie is saved', (
    tester,
  ) async {
    stubDetail(const MovieDetailHasData(testMovieDetail));
    stubRecommendations(const MovieListEmpty());
    stubWatchlist(
      const WatchlistMovieStatusState(),
      stream: Stream.fromIterable([
        const WatchlistMovieStatusState(),
        const WatchlistMovieStatusState(
          isAddedToWatchlist: true,
          message: WatchlistMovieStatusBloc.watchlistAddSuccessMessage,
        ),
      ]),
    );

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text(WatchlistMovieStatusBloc.watchlistAddSuccessMessage),
      findsOneWidget,
    );
  });

  testWidgets('should show a dialog when saving the movie fails', (
    tester,
  ) async {
    stubDetail(const MovieDetailHasData(testMovieDetail));
    stubRecommendations(const MovieListEmpty());
    stubWatchlist(
      const WatchlistMovieStatusState(),
      stream: Stream.fromIterable([
        const WatchlistMovieStatusState(),
        const WatchlistMovieStatusState(message: 'Failed'),
      ]),
    );

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('should display the recommendation list when it is loaded', (
    tester,
  ) async {
    stubDetail(const MovieDetailHasData(testMovieDetail));
    stubRecommendations(MovieListHasData(testMovieList));
    stubWatchlist(const WatchlistMovieStatusState());

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.byKey(Key('recommendation_${testMovie.id}')), findsOneWidget);
  });

  testWidgets('should display an error text when recommendations fail', (
    tester,
  ) async {
    stubDetail(const MovieDetailHasData(testMovieDetail));
    stubRecommendations(const MovieListError('Failed to load'));
    stubWatchlist(const WatchlistMovieStatusState());

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.text('Failed to load'), findsOneWidget);
  });

  testWidgets('should display nothing before the detail is requested', (
    tester,
  ) async {
    stubDetail(const MovieDetailEmpty());
    stubRecommendations(const MovieListEmpty());
    stubWatchlist(const WatchlistMovieStatusState());

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );

    expect(find.byType(DetailContent), findsNothing);
  });

  testWidgets('should pop the page when the back button is tapped', (
    tester,
  ) async {
    stubDetail(const MovieDetailHasData(testMovieDetail));
    stubRecommendations(const MovieListEmpty());
    stubWatchlist(const WatchlistMovieStatusState());

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<MovieDetailBloc>.value(value: mockDetailBloc),
          BlocProvider<MovieRecommendationsBloc>.value(
            value: mockRecommendationsBloc,
          ),
          BlocProvider<WatchlistMovieStatusBloc>.value(
            value: mockWatchlistBloc,
          ),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => MovieDetailPage(key: UniqueKey(), id: 1),
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
    expect(find.byType(MovieDetailPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(MovieDetailPage), findsNothing);
  });

  testWidgets('should open another movie from the recommendation list', (
    tester,
  ) async {
    stubDetail(const MovieDetailHasData(testMovieDetail));
    stubRecommendations(MovieListHasData(testMovieList));
    stubWatchlist(const WatchlistMovieStatusState());
    var routeName = '';

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<MovieDetailBloc>.value(value: mockDetailBloc),
          BlocProvider<MovieRecommendationsBloc>.value(
            value: mockRecommendationsBloc,
          ),
          BlocProvider<WatchlistMovieStatusBloc>.value(
            value: mockWatchlistBloc,
          ),
        ],
        child: MaterialApp(
          home: MovieDetailPage(key: UniqueKey(), id: 1),
          onGenerateRoute: (settings) {
            routeName = settings.name ?? '';
            return MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: Text('page')),
            );
          },
        ),
      ),
    );
    await tester.pump();

    final recommendation = find.byKey(Key('recommendation_${testMovie.id}'));
    await tester.ensureVisible(recommendation);
    await tester.pump();
    await tester.tap(recommendation);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(routeName, AppRoutes.movieDetail);
  });

  testWidgets('should display the duration in minutes for short movies', (
    tester,
  ) async {
    const shortMovie = MovieDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 45,
      title: 'title',
      voteAverage: 1,
      voteCount: 1,
    );
    stubDetail(const MovieDetailHasData(shortMovie));
    stubRecommendations(const MovieListEmpty());
    stubWatchlist(const WatchlistMovieStatusState());

    await tester.pumpWidget(
      makeTestableWidget(MovieDetailPage(key: UniqueKey(), id: 1)),
    );
    await tester.pump();

    expect(find.text('45m'), findsOneWidget);
  });
}
