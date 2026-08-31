import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlist(mockMovieRepository);
  });

  test('should remove movie from the repository', () async {
    // arrange
    when(
      mockMovieRepository.removeWatchlist(testMovieDetail),
    ).thenAnswer((_) async => const Right('Removed from Watchlist'));
    // act
    final result = await usecase.execute(testMovieDetail);
    // assert
    expect(result, const Right('Removed from Watchlist'));
    verify(mockMovieRepository.removeWatchlist(testMovieDetail));
  });

  test('should return failure when removing fails', () async {
    // arrange
    when(mockMovieRepository.removeWatchlist(testMovieDetail)).thenAnswer(
      (_) async => const Left(DatabaseFailure('Failed to remove watchlist')),
    );
    // act
    final result = await usecase.execute(testMovieDetail);
    // assert
    expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
  });
}
