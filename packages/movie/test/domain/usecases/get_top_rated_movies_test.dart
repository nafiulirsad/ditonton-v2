import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTopRatedMovies(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(
      mockMovieRepository.getTopRatedMovies(),
    ).thenAnswer((_) async => Right(testMovieList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testMovieList));
    verify(mockMovieRepository.getTopRatedMovies());
  });

  test('should return failure when the repository fails', () async {
    // arrange
    when(
      mockMovieRepository.getTopRatedMovies(),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, const Left(ServerFailure('Server Failure')));
  });
}
