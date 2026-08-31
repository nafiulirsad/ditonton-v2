import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/bloc_helper.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  late MockTopRatedTvSeriesBloc mockBloc;

  setUp(() {
    setUpWidgetTest();
    mockBloc = MockTopRatedTvSeriesBloc();
  });

  void stub(TvSeriesListState state) {
    whenListen(mockBloc, Stream.value(state), initialState: state);
  }

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display a progress indicator while loading', (
    tester,
  ) async {
    stub(const TvSeriesListLoading());

    await tester.pumpWidget(
      makeTestableWidget(TopRatedTvSeriesPage(key: UniqueKey())),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display a ListView when the data is loaded', (
    tester,
  ) async {
    stub(TvSeriesListHasData(testTvSeriesList));

    await tester.pumpWidget(
      makeTestableWidget(TopRatedTvSeriesPage(key: UniqueKey())),
    );
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvSeriesCard), findsOneWidget);
  });

  testWidgets('should display an error message when the request fails', (
    tester,
  ) async {
    stub(const TvSeriesListError('Error message'));

    await tester.pumpWidget(
      makeTestableWidget(TopRatedTvSeriesPage(key: UniqueKey())),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should display nothing before any request is made', (
    tester,
  ) async {
    stub(const TvSeriesListEmpty());

    await tester.pumpWidget(
      makeTestableWidget(TopRatedTvSeriesPage(key: UniqueKey())),
    );

    expect(find.byType(ListView), findsNothing);
  });
}
