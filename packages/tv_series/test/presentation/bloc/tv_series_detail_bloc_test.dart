import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late TvSeriesDetailBloc bloc;

  const id = 1;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    bloc = TvSeriesDetailBloc(mockGetTvSeriesDetail);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state, const TvSeriesDetailEmpty());
  });

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should emit [Loading, HasData] when the detail is fetched successfully',
    build: () {
      when(
        mockGetTvSeriesDetail.execute(id),
      ).thenAnswer((_) async => const Right(testTvSeriesDetail));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchTvSeriesDetail(id)),
    expect: () => [
      const TvSeriesDetailLoading(),
      const TvSeriesDetailHasData(testTvSeriesDetail),
    ],
    verify: (_) => verify(mockGetTvSeriesDetail.execute(id)),
  );

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should emit [Loading, Error] when fetching the detail fails',
    build: () {
      when(
        mockGetTvSeriesDetail.execute(id),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchTvSeriesDetail(id)),
    expect: () => [
      const TvSeriesDetailLoading(),
      const TvSeriesDetailError('Server Failure'),
    ],
  );
}
