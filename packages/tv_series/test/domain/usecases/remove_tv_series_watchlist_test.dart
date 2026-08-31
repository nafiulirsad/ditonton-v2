import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvSeriesWatchlist usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveTvSeriesWatchlist(mockTvSeriesRepository);
  });

  test('should remove tv series from the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail),
    ).thenAnswer((_) async => const Right('Removed from Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    expect(result, const Right('Removed from Watchlist'));
    verify(mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail));
  });

  test('should return failure when removing fails', () async {
    // arrange
    when(mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail)).thenAnswer(
      (_) async => const Left(DatabaseFailure('Failed to remove watchlist')),
    );
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
  });
}
