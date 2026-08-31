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
  late MockWatchlistMoviesBloc mockBloc;

  setUp(() {
    setUpWidgetTest();
    mockBloc = MockWatchlistMoviesBloc();
  });

  void stub(MovieListState state) {
    whenListen(mockBloc, Stream.value(state), initialState: state);
  }

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: Scaffold(body: body)),
    );
  }

  testWidgets('should display a progress indicator while loading', (
    tester,
  ) async {
    stub(const MovieListLoading());

    await tester.pumpWidget(
      makeTestableWidget(WatchlistMoviesPage(key: UniqueKey())),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display the watchlist when the data is loaded', (
    tester,
  ) async {
    stub(MovieListHasData(testMovieList));

    await tester.pumpWidget(
      makeTestableWidget(WatchlistMoviesPage(key: UniqueKey())),
    );
    await tester.pump();

    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('should display an empty message when the watchlist is empty', (
    tester,
  ) async {
    stub(const MovieListHasData([]));

    await tester.pumpWidget(
      makeTestableWidget(WatchlistMoviesPage(key: UniqueKey())),
    );
    await tester.pump();

    expect(find.byKey(const Key('empty_message')), findsOneWidget);
  });

  testWidgets('should display an error message when loading fails', (
    tester,
  ) async {
    stub(const MovieListError('Error message'));

    await tester.pumpWidget(
      makeTestableWidget(WatchlistMoviesPage(key: UniqueKey())),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display nothing before the watchlist is requested', (
    tester,
  ) async {
    stub(const MovieListEmpty());

    await tester.pumpWidget(
      makeTestableWidget(WatchlistMoviesPage(key: UniqueKey())),
    );

    expect(find.byType(MovieCard), findsNothing);
  });

  testWidgets('should refresh the watchlist after returning to the page', (
    tester,
  ) async {
    stub(MovieListHasData(testMovieList));

    await tester.pumpWidget(
      BlocProvider<WatchlistMoviesBloc>.value(
        value: mockBloc,
        child: MaterialApp(
          navigatorObservers: [routeObserver],
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  Expanded(child: WatchlistMoviesPage(key: UniqueKey())),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const Scaffold(body: Text('detail')),
                      ),
                    ),
                    child: const Text('open'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    verify(
      () => mockBloc.add(const FetchWatchlistMovies()),
    ).called(greaterThan(1));
  });
}
