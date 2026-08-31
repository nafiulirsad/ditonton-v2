import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockSearchTvSeries mockSearchTvSeries;
  late TvSeriesSearchBloc bloc;

  const query = 'game of thrones';

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    bloc = TvSeriesSearchBloc(mockSearchTvSeries);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state, const TvSeriesListEmpty());
  });

  blocTest<TvSeriesSearchBloc, TvSeriesListState>(
    'should emit [Loading, HasData] when the search succeeds',
    build: () {
      when(
        mockSearchTvSeries.execute(query),
      ).thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnTvSeriesQueryChanged(query)),
    wait:
        TvSeriesSearchBloc.debounceDuration + const Duration(milliseconds: 300),
    expect: () => [
      const TvSeriesListLoading(),
      TvSeriesListHasData(testTvSeriesList),
    ],
    verify: (_) => verify(mockSearchTvSeries.execute(query)),
  );

  blocTest<TvSeriesSearchBloc, TvSeriesListState>(
    'should emit [Loading, Error] when the search fails',
    build: () {
      when(
        mockSearchTvSeries.execute(query),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnTvSeriesQueryChanged(query)),
    wait:
        TvSeriesSearchBloc.debounceDuration + const Duration(milliseconds: 300),
    expect: () => [
      const TvSeriesListLoading(),
      const TvSeriesListError('Server Failure'),
    ],
  );

  blocTest<TvSeriesSearchBloc, TvSeriesListState>(
    'should emit empty and skip the use case when the query is blank',
    build: () => bloc,
    act: (bloc) => bloc.add(const OnTvSeriesQueryChanged('')),
    wait:
        TvSeriesSearchBloc.debounceDuration + const Duration(milliseconds: 300),
    expect: () => [const TvSeriesListEmpty()],
    verify: (_) => verifyNever(mockSearchTvSeries.execute('')),
  );

  blocTest<TvSeriesSearchBloc, TvSeriesListState>(
    'should only process the last query while typing',
    build: () {
      when(
        mockSearchTvSeries.execute(query),
      ).thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc
      ..add(const OnTvSeriesQueryChanged('game'))
      ..add(const OnTvSeriesQueryChanged(query)),
    wait:
        TvSeriesSearchBloc.debounceDuration + const Duration(milliseconds: 300),
    expect: () => [
      const TvSeriesListLoading(),
      TvSeriesListHasData(testTvSeriesList),
    ],
    verify: (_) {
      verify(mockSearchTvSeries.execute(query));
      verifyNever(mockSearchTvSeries.execute('game'));
    },
  );
}
