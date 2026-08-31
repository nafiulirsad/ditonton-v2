import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlist(mockMovieRepository);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(
      mockMovieRepository.saveWatchlist(testMovieDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testMovieDetail);
    // assert
    expect(result, const Right('Added to Watchlist'));
    verify(mockMovieRepository.saveWatchlist(testMovieDetail));
  });

  test('should return failure when saving fails', () async {
    // arrange
    when(mockMovieRepository.saveWatchlist(testMovieDetail)).thenAnswer(
      (_) async => const Left(DatabaseFailure('Failed to add watchlist')),
    );
    // act
    final result = await usecase.execute(testMovieDetail);
    // assert
    expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
  });
}
