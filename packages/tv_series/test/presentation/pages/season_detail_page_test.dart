import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/bloc_helper.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  late MockSeasonDetailBloc mockBloc;

  const args = SeasonDetailArgs(
    tvSeriesId: 1,
    seasonNumber: 1,
    seasonName: 'Season 1',
  );

  setUp(() {
    setUpWidgetTest();
    mockBloc = MockSeasonDetailBloc();
  });

  void stub(SeasonDetailState state) {
    whenListen(mockBloc, Stream.value(state), initialState: state);
  }

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SeasonDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display a progress indicator while loading', (
    tester,
  ) async {
    stub(const SeasonDetailLoading());

    await tester.pumpWidget(
      makeTestableWidget(SeasonDetailPage(key: UniqueKey(), args: args)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display the episode list when the data is loaded', (
    tester,
  ) async {
    stub(const SeasonDetailHasData(testSeasonDetail));

    await tester.pumpWidget(
      makeTestableWidget(SeasonDetailPage(key: UniqueKey(), args: args)),
    );
    await tester.pump();

    expect(find.byKey(const Key('episode_list')), findsOneWidget);
    expect(find.byType(EpisodeCard), findsOneWidget);
  });

  testWidgets(
    'should display an empty message when the season has no episode',
    (tester) async {
      stub(
        const SeasonDetailHasData(
          SeasonDetail(
            airDate: '2020-05-05',
            episodes: [],
            id: 1,
            name: 'Season 1',
            overview: 'Overview',
            posterPath: '/path.jpg',
            seasonNumber: 1,
          ),
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(SeasonDetailPage(key: UniqueKey(), args: args)),
      );
      await tester.pump();

      expect(find.byKey(const Key('empty_message')), findsOneWidget);
    },
  );

  testWidgets('should display an error message when the request fails', (
    tester,
  ) async {
    stub(const SeasonDetailError('Server Failure'));

    await tester.pumpWidget(
      makeTestableWidget(SeasonDetailPage(key: UniqueKey(), args: args)),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display nothing before the season is requested', (
    tester,
  ) async {
    stub(const SeasonDetailEmpty());

    await tester.pumpWidget(
      makeTestableWidget(SeasonDetailPage(key: UniqueKey(), args: args)),
    );

    expect(find.byType(EpisodeCard), findsNothing);
  });
}
