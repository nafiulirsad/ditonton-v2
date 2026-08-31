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
  late MockWatchlistTvSeriesBloc mockBloc;

  setUp(() {
    setUpWidgetTest();
    mockBloc = MockWatchlistTvSeriesBloc();
  });

  void stub(TvSeriesListState state) {
    whenListen(mockBloc, Stream.value(state), initialState: state);
  }

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: Scaffold(body: body)),
    );
  }

  testWidgets('should display a progress indicator while loading', (
    tester,
  ) async {
    stub(const TvSeriesListLoading());

    await tester.pumpWidget(
      makeTestableWidget(WatchlistTvSeriesPage(key: UniqueKey())),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display the watchlist when the data is loaded', (
    tester,
  ) async {
    stub(TvSeriesListHasData(testTvSeriesList));

    await tester.pumpWidget(
      makeTestableWidget(WatchlistTvSeriesPage(key: UniqueKey())),
    );
    await tester.pump();

    expect(find.byType(TvSeriesCard), findsOneWidget);
  });

  testWidgets('should display an empty message when the watchlist is empty', (
    tester,
  ) async {
    stub(const TvSeriesListHasData([]));

    await tester.pumpWidget(
      makeTestableWidget(WatchlistTvSeriesPage(key: UniqueKey())),
    );
    await tester.pump();

    expect(find.byKey(const Key('empty_message')), findsOneWidget);
  });

  testWidgets('should display an error message when loading fails', (
    tester,
  ) async {
    stub(const TvSeriesListError('Error message'));

    await tester.pumpWidget(
      makeTestableWidget(WatchlistTvSeriesPage(key: UniqueKey())),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display nothing before the watchlist is requested', (
    tester,
  ) async {
    stub(const TvSeriesListEmpty());

    await tester.pumpWidget(
      makeTestableWidget(WatchlistTvSeriesPage(key: UniqueKey())),
    );

    expect(find.byType(TvSeriesCard), findsNothing);
  });

  testWidgets('should refresh the watchlist after returning to the page', (
    tester,
  ) async {
    stub(TvSeriesListHasData(testTvSeriesList));

    await tester.pumpWidget(
      BlocProvider<WatchlistTvSeriesBloc>.value(
        value: mockBloc,
        child: MaterialApp(
          navigatorObservers: [routeObserver],
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  Expanded(child: WatchlistTvSeriesPage(key: UniqueKey())),
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
      () => mockBloc.add(const FetchWatchlistTvSeries()),
    ).called(greaterThan(1));
  });
}
