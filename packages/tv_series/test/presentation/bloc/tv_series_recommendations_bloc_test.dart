import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late TvSeriesRecommendationsBloc bloc;

  const id = 1;

  setUp(() {
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    bloc = TvSeriesRecommendationsBloc(mockGetTvSeriesRecommendations);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state, const TvSeriesListEmpty());
  });

  blocTest<TvSeriesRecommendationsBloc, TvSeriesListState>(
    'should emit [Loading, HasData] when recommendations are fetched',
    build: () {
      when(
        mockGetTvSeriesRecommendations.execute(id),
      ).thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchTvSeriesRecommendations(id)),
    expect: () => [
      const TvSeriesListLoading(),
      TvSeriesListHasData(testTvSeriesList),
    ],
    verify: (_) => verify(mockGetTvSeriesRecommendations.execute(id)),
  );

  blocTest<TvSeriesRecommendationsBloc, TvSeriesListState>(
    'should emit [Loading, Error] when fetching recommendations fails',
    build: () {
      when(
        mockGetTvSeriesRecommendations.execute(id),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchTvSeriesRecommendations(id)),
    expect: () => [
      const TvSeriesListLoading(),
      const TvSeriesListError('Server Failure'),
    ],
  );
}
