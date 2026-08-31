import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetSeasonDetail usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetSeasonDetail(mockTvSeriesRepository);
  });

  const tId = 1;
  const tSeasonNumber = 1;

  test('should get season detail from the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.getSeasonDetail(tId, tSeasonNumber),
    ).thenAnswer((_) async => const Right(testSeasonDetail));
    // act
    final result = await usecase.execute(tId, tSeasonNumber);
    // assert
    expect(result, const Right(testSeasonDetail));
    verify(mockTvSeriesRepository.getSeasonDetail(tId, tSeasonNumber));
  });

  test('should return failure when the repository fails', () async {
    // arrange
    when(
      mockTvSeriesRepository.getSeasonDetail(tId, tSeasonNumber),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    final result = await usecase.execute(tId, tSeasonNumber);
    // assert
    expect(result, const Left(ServerFailure('Server Failure')));
  });
}
