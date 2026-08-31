import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/bloc_helper.dart';
import '../../helpers/widget_test_helper.dart';

void main() {
  late MockOnTheAirTvSeriesBloc mockOnTheAirBloc;
  late MockPopularTvSeriesBloc mockPopularBloc;
  late MockTopRatedTvSeriesBloc mockTopRatedBloc;

  setUp(() {
    setUpWidgetTest();
    mockOnTheAirBloc = MockOnTheAirTvSeriesBloc();
    mockPopularBloc = MockPopularTvSeriesBloc();
    mockTopRatedBloc = MockTopRatedTvSeriesBloc();
  });

  void stubAll(TvSeriesListState state) {
    whenListen(mockOnTheAirBloc, Stream.value(state), initialState: state);
    whenListen(mockPopularBloc, Stream.value(state), initialState: state);
    whenListen(mockTopRatedBloc, Stream.value(state), initialState: state);
  }

  Widget makeTestableWidget(Widget body, {RouteFactory? onGenerateRoute}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnTheAirTvSeriesBloc>.value(value: mockOnTheAirBloc),
        BlocProvider<PopularTvSeriesBloc>.value(value: mockPopularBloc),
        BlocProvider<TopRatedTvSeriesBloc>.value(value: mockTopRatedBloc),
      ],
      child: MaterialApp(home: body, onGenerateRoute: onGenerateRoute),
    );
  }

  testWidgets('should display a progress indicator for every section', (
    tester,
  ) async {
    stubAll(const TvSeriesListLoading());

    await tester.pumpWidget(
      makeTestableWidget(HomeTvSeriesPage(key: UniqueKey())),
    );

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('should display the tv series lists when the data is loaded', (
    tester,
  ) async {
    stubAll(TvSeriesListHasData(testTvSeriesList));

    await tester.pumpWidget(
      makeTestableWidget(HomeTvSeriesPage(key: UniqueKey())),
    );
    await tester.pump();

    expect(find.byType(TvSeriesList), findsNWidgets(3));
  });

  testWidgets('should display a failure text when the request fails', (
    tester,
  ) async {
    stubAll(const TvSeriesListError('Server Failure'));

    await tester.pumpWidget(
      makeTestableWidget(HomeTvSeriesPage(key: UniqueKey())),
    );

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('should open the search page from the app bar', (tester) async {
    stubAll(TvSeriesListHasData(testTvSeriesList));
    var routeName = '';

    await tester.pumpWidget(
      makeTestableWidget(
        const HomeTvSeriesPage(),
        onGenerateRoute: (settings) {
          routeName = settings.name ?? '';
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('page')),
          );
        },
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('search_tv_series_button')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(routeName, AppRoutes.searchTvSeries);
  });

  testWidgets('should open the on the air page from See More', (tester) async {
    stubAll(TvSeriesListHasData(testTvSeriesList));
    final routeNames = <String>[];

    await tester.pumpWidget(
      makeTestableWidget(
        HomeTvSeriesPage(key: UniqueKey()),
        onGenerateRoute: (settings) {
          routeNames.add(settings.name ?? '');
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('page')),
          );
        },
      ),
    );
    await tester.pump();

    for (var index = 0; index < 3; index++) {
      await tester.tap(find.text('See More').at(index));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    expect(routeNames, contains(AppRoutes.onTheAirTvSeries));
    expect(routeNames, contains(AppRoutes.popularTvSeries));
    expect(routeNames, contains(AppRoutes.topRatedTvSeries));
  });

  testWidgets('should open the tv series detail page from the poster', (
    tester,
  ) async {
    stubAll(TvSeriesListHasData(testTvSeriesList));
    var routeName = '';
    Object? arguments;

    await tester.pumpWidget(
      makeTestableWidget(
        HomeTvSeriesPage(key: UniqueKey()),
        onGenerateRoute: (settings) {
          routeName = settings.name ?? '';
          arguments = settings.arguments;
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('page')),
          );
        },
      ),
    );
    await tester.pump();

    await tester.tap(
      find
          .descendant(
            of: find.byType(TvSeriesList).first,
            matching: find.byType(InkWell),
          )
          .first,
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(routeName, AppRoutes.tvSeriesDetail);
    expect(arguments, testTvSeries.id);
  });
}
