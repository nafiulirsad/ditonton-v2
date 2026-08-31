import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/bloc_helper.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  late MockMovieSearchBloc mockBloc;

  setUp(() {
    setUpWidgetTest();
    mockBloc = MockMovieSearchBloc();
  });

  void stub(MovieListState state) {
    whenListen(mockBloc, Stream.value(state), initialState: state);
  }

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieSearchBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display a progress indicator while searching', (
    tester,
  ) async {
    stub(const MovieListLoading());

    await tester.pumpWidget(makeTestableWidget(SearchPage(key: UniqueKey())));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display the result list when the search succeeds', (
    tester,
  ) async {
    stub(MovieListHasData(testMovieList));

    await tester.pumpWidget(makeTestableWidget(SearchPage(key: UniqueKey())));
    await tester.pump();

    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('should display an error message when the search fails', (
    tester,
  ) async {
    stub(const MovieListError('Error message'));

    await tester.pumpWidget(makeTestableWidget(SearchPage(key: UniqueKey())));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display nothing before a query is entered', (
    tester,
  ) async {
    stub(const MovieListEmpty());

    await tester.pumpWidget(makeTestableWidget(SearchPage(key: UniqueKey())));

    expect(find.byType(MovieCard), findsNothing);
  });

  testWidgets('should send the query to the bloc while typing', (tester) async {
    stub(const MovieListEmpty());

    await tester.pumpWidget(makeTestableWidget(SearchPage(key: UniqueKey())));
    await tester.enterText(find.byKey(const Key('query_input')), 'spiderman');
    await tester.pump();

    verify(
      () => mockBloc.add(const OnMovieQueryChanged('spiderman')),
    ).called(1);
  });

  testWidgets('should send the query to the bloc when submitted', (
    tester,
  ) async {
    stub(const MovieListEmpty());

    await tester.pumpWidget(makeTestableWidget(SearchPage(key: UniqueKey())));
    await tester.enterText(find.byKey(const Key('query_input')), 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(
      () => mockBloc.add(const OnMovieQueryChanged('spiderman')),
    ).called(2);
  });
}
