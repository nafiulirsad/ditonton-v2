import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetPopularTvSeries mockUseCase;
  late PopularTvSeriesBloc bloc;

  setUp(() {
    mockUseCase = MockGetPopularTvSeries();
    bloc = PopularTvSeriesBloc(mockUseCase);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state, const TvSeriesListEmpty());
  });

  blocTest<PopularTvSeriesBloc, TvSeriesListState>(
    'should emit [Loading, HasData] when the data is fetched successfully',
    build: () {
      when(
        mockUseCase.execute(),
      ).thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchPopularTvSeries()),
    expect: () => [
      const TvSeriesListLoading(),
      TvSeriesListHasData(testTvSeriesList),
    ],
    verify: (_) => verify(mockUseCase.execute()),
  );

  blocTest<PopularTvSeriesBloc, TvSeriesListState>(
    'should emit [Loading, Error] when fetching the data fails',
    build: () {
      when(
        mockUseCase.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchPopularTvSeries()),
    expect: () => [
      const TvSeriesListLoading(),
      const TvSeriesListError('Server Failure'),
    ],
    verify: (_) => verify(mockUseCase.execute()),
  );
}
