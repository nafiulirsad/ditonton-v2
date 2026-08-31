import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetSeasonDetail mockGetSeasonDetail;
  late SeasonDetailBloc bloc;

  const id = 1;
  const seasonNumber = 1;

  setUp(() {
    mockGetSeasonDetail = MockGetSeasonDetail();
    bloc = SeasonDetailBloc(mockGetSeasonDetail);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state, const SeasonDetailEmpty());
  });

  blocTest<SeasonDetailBloc, SeasonDetailState>(
    'should emit [Loading, HasData] when the season is fetched successfully',
    build: () {
      when(
        mockGetSeasonDetail.execute(id, seasonNumber),
      ).thenAnswer((_) async => const Right(testSeasonDetail));
      return bloc;
    },
    act: (bloc) =>
        bloc.add(const FetchSeasonDetail(id: id, seasonNumber: seasonNumber)),
    expect: () => [
      const SeasonDetailLoading(),
      const SeasonDetailHasData(testSeasonDetail),
    ],
    verify: (_) => verify(mockGetSeasonDetail.execute(id, seasonNumber)),
  );

  blocTest<SeasonDetailBloc, SeasonDetailState>(
    'should emit [Loading, Error] when fetching the season fails',
    build: () {
      when(
        mockGetSeasonDetail.execute(id, seasonNumber),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) =>
        bloc.add(const FetchSeasonDetail(id: id, seasonNumber: seasonNumber)),
    expect: () => [
      const SeasonDetailLoading(),
      const SeasonDetailError('Server Failure'),
    ],
  );
}
