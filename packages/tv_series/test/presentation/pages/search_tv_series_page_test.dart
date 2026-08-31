import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/bloc_helper.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  late MockTvSeriesSearchBloc mockBloc;

  setUp(() {
    setUpWidgetTest();
    mockBloc = MockTvSeriesSearchBloc();
  });

  void stub(TvSeriesListState state) {
    whenListen(mockBloc, Stream.value(state), initialState: state);
  }

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesSearchBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display a progress indicator while searching', (
    tester,
  ) async {
    stub(const TvSeriesListLoading());

    await tester.pumpWidget(
      makeTestableWidget(SearchTvSeriesPage(key: UniqueKey())),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display the result list when the search succeeds', (
    tester,
  ) async {
    stub(TvSeriesListHasData(testTvSeriesList));

    await tester.pumpWidget(
      makeTestableWidget(SearchTvSeriesPage(key: UniqueKey())),
    );
    await tester.pump();

    expect(find.byType(TvSeriesCard), findsOneWidget);
  });

  testWidgets('should display an error message when the search fails', (
    tester,
  ) async {
    stub(const TvSeriesListError('Error message'));

    await tester.pumpWidget(
      makeTestableWidget(SearchTvSeriesPage(key: UniqueKey())),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display nothing before a query is entered', (
    tester,
  ) async {
    stub(const TvSeriesListEmpty());

    await tester.pumpWidget(
      makeTestableWidget(SearchTvSeriesPage(key: UniqueKey())),
    );

    expect(find.byType(TvSeriesCard), findsNothing);
  });

  testWidgets('should send the query to the bloc while typing', (tester) async {
    stub(const TvSeriesListEmpty());

    await tester.pumpWidget(
      makeTestableWidget(SearchTvSeriesPage(key: UniqueKey())),
    );
    await tester.enterText(find.byKey(const Key('query_input')), 'thrones');
    await tester.pump();

    verify(
      () => mockBloc.add(const OnTvSeriesQueryChanged('thrones')),
    ).called(1);
  });

  testWidgets('should send the query to the bloc when submitted', (
    tester,
  ) async {
    stub(const TvSeriesListEmpty());

    await tester.pumpWidget(
      makeTestableWidget(SearchTvSeriesPage(key: UniqueKey())),
    );
    await tester.enterText(find.byKey(const Key('query_input')), 'thrones');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(
      () => mockBloc.add(const OnTvSeriesQueryChanged('thrones')),
    ).called(2);
  });
}
