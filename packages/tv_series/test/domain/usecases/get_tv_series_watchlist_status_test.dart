import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesWatchListStatus usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesWatchListStatus(mockTvSeriesRepository);
  });

  test('should get watchlist status from the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.isAddedToWatchlist(1),
    ).thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
    verify(mockTvSeriesRepository.isAddedToWatchlist(1));
  });

  test(
    'should return false when the tv series is not on the watchlist',
    () async {
      // arrange
      when(
        mockTvSeriesRepository.isAddedToWatchlist(1),
      ).thenAnswer((_) async => false);
      // act
      final result = await usecase.execute(1);
      // assert
      expect(result, false);
    },
  );
}
