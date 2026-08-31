import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetPopularTvSeries(mockTvSeriesRepository);
  });

  test('should get list of tv series from the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.getPopularTvSeries(),
    ).thenAnswer((_) async => Right(testTvSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvSeriesList));
    verify(mockTvSeriesRepository.getPopularTvSeries());
  });

  test('should return failure when the repository fails', () async {
    // arrange
    when(
      mockTvSeriesRepository.getPopularTvSeries(),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, const Left(ServerFailure('Server Failure')));
  });
}
