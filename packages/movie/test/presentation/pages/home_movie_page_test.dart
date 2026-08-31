import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/bloc_helper.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  late MockNowPlayingMoviesBloc mockNowPlayingBloc;
  late MockPopularMoviesBloc mockPopularBloc;
  late MockTopRatedMoviesBloc mockTopRatedBloc;

  setUp(() {
    setUpWidgetTest();
    mockNowPlayingBloc = MockNowPlayingMoviesBloc();
    mockPopularBloc = MockPopularMoviesBloc();
    mockTopRatedBloc = MockTopRatedMoviesBloc();
  });

  void stubAll(MovieListState state) {
    whenListen(mockNowPlayingBloc, Stream.value(state), initialState: state);
    whenListen(mockPopularBloc, Stream.value(state), initialState: state);
    whenListen(mockTopRatedBloc, Stream.value(state), initialState: state);
  }

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMoviesBloc>.value(value: mockNowPlayingBloc),
        BlocProvider<PopularMoviesBloc>.value(value: mockPopularBloc),
        BlocProvider<TopRatedMoviesBloc>.value(value: mockTopRatedBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display a progress indicator for every section', (
    tester,
  ) async {
    stubAll(const MovieListLoading());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('should display the movie lists when the data is loaded', (
    tester,
  ) async {
    stubAll(MovieListHasData(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));
    await tester.pump();

    expect(find.byType(MovieList), findsNWidgets(3));
  });

  testWidgets('should display a failure text when the request fails', (
    tester,
  ) async {
    stubAll(const MovieListError('Server Failure'));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('should open the search page from the app bar', (tester) async {
    stubAll(MovieListHasData(testMovieList));
    var routeName = '';

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingMoviesBloc>.value(value: mockNowPlayingBloc),
          BlocProvider<PopularMoviesBloc>.value(value: mockPopularBloc),
          BlocProvider<TopRatedMoviesBloc>.value(value: mockTopRatedBloc),
        ],
        child: MaterialApp(
          home: const HomeMoviePage(),
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

    await tester.tap(find.byKey(const Key('search_movie_button')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(routeName, AppRoutes.searchMovies);
  });

  testWidgets('should open the popular and top rated pages from See More', (
    tester,
  ) async {
    stubAll(MovieListHasData(testMovieList));
    final routeNames = <String>[];

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingMoviesBloc>.value(value: mockNowPlayingBloc),
          BlocProvider<PopularMoviesBloc>.value(value: mockPopularBloc),
          BlocProvider<TopRatedMoviesBloc>.value(value: mockTopRatedBloc),
        ],
        child: MaterialApp(
          home: HomeMoviePage(key: UniqueKey()),
          onGenerateRoute: (settings) {
            routeNames.add(settings.name ?? '');
            return MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: Text('page')),
            );
          },
        ),
      ),
    );
    await tester.pump();

    for (var index = 0; index < 2; index++) {
      await tester.tap(find.text('See More').at(index));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    expect(routeNames, contains(AppRoutes.popularMovies));
    expect(routeNames, contains(AppRoutes.topRatedMovies));
  });

  testWidgets('should open the movie detail page from the poster', (
    tester,
  ) async {
    stubAll(MovieListHasData(testMovieList));
    var routeName = '';
    Object? arguments;

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingMoviesBloc>.value(value: mockNowPlayingBloc),
          BlocProvider<PopularMoviesBloc>.value(value: mockPopularBloc),
          BlocProvider<TopRatedMoviesBloc>.value(value: mockTopRatedBloc),
        ],
        child: MaterialApp(
          home: HomeMoviePage(key: UniqueKey()),
          onGenerateRoute: (settings) {
            routeName = settings.name ?? '';
            arguments = settings.arguments;
            return MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: Text('page')),
            );
          },
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(InkWell).first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(routeName, AppRoutes.movieDetail);
    expect(arguments, testMovie.id);
  });
}
