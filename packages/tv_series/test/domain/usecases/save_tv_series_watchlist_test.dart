import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvSeriesWatchlist usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveTvSeriesWatchlist(mockTvSeriesRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.saveWatchlist(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    expect(result, const Right('Added to Watchlist'));
    verify(mockTvSeriesRepository.saveWatchlist(testTvSeriesDetail));
  });

  test('should return failure when saving fails', () async {
    // arrange
    when(mockTvSeriesRepository.saveWatchlist(testTvSeriesDetail)).thenAnswer(
      (_) async => const Left(DatabaseFailure('Failed to add watchlist')),
    );
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
  });
}
