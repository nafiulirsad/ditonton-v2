import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  /// Menjalankan skenario sukses, ServerException, dan SocketException untuk
  /// setiap metode repository yang mengembalikan daftar film.
  void testMovieListMethod({
    required String description,
    required Future<List<dynamic>> Function() stubTarget,
    required Future<Either<Failure, List<Movie>>> Function() act,
  }) {
    group(description, () {
      test(
        'should return a list of movies when the call is successful',
        () async {
          // arrange
          when(stubTarget()).thenAnswer((_) async => testMovieModelList);
          // act
          final result = await act();
          // assert
          expect(result.getOrElse(() => []), testMovieFromModelList);
        },
      );

      test(
        'should return a ServerFailure when the call is unsuccessful',
        () async {
          // arrange
          when(stubTarget()).thenThrow(ServerException());
          // act
          final result = await act();
          // assert
          expect(result, const Left(ServerFailure('')));
        },
      );

      test(
        'should return a ConnectionFailure when the device is offline',
        () async {
          // arrange
          when(
            stubTarget(),
          ).thenThrow(const SocketException('Failed to connect'));
          // act
          final result = await act();
          // assert
          expect(
            result,
            const Left(ConnectionFailure('Failed to connect to the network')),
          );
        },
      );
    });
  }

  testMovieListMethod(
    description: 'Now Playing Movies',
    stubTarget: () => mockRemoteDataSource.getNowPlayingMovies(),
    act: () => repository.getNowPlayingMovies(),
  );

  testMovieListMethod(
    description: 'Popular Movies',
    stubTarget: () => mockRemoteDataSource.getPopularMovies(),
    act: () => repository.getPopularMovies(),
  );

  testMovieListMethod(
    description: 'Top Rated Movies',
    stubTarget: () => mockRemoteDataSource.getTopRatedMovies(),
    act: () => repository.getTopRatedMovies(),
  );

  testMovieListMethod(
    description: 'Movie Recommendations',
    stubTarget: () => mockRemoteDataSource.getMovieRecommendations(1),
    act: () => repository.getMovieRecommendations(1),
  );

  testMovieListMethod(
    description: 'Search Movies',
    stubTarget: () => mockRemoteDataSource.searchMovies('spiderman'),
    act: () => repository.searchMovies('spiderman'),
  );

  group('Get Movie Detail', () {
    const tId = 1;
    const tMovieResponse = MovieDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      budget: 100,
      genres: [],
      homepage: 'homepage',
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test('should return a movie detail when the call is successful', () async {
      // arrange
      when(
        mockRemoteDataSource.getMovieDetail(tId),
      ).thenAnswer((_) async => tMovieResponse);
      // act
      final result = await repository.getMovieDetail(tId);
      // assert
      expect(result, Right(tMovieResponse.toEntity()));
    });

    test(
      'should return a ServerFailure when the call is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getMovieDetail(tId),
        ).thenThrow(ServerException());
        final result = await repository.getMovieDetail(tId);
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return a ConnectionFailure when the device is offline',
      () async {
        when(
          mockRemoteDataSource.getMovieDetail(tId),
        ).thenThrow(const SocketException('Failed to connect'));
        final result = await repository.getMovieDetail(tId);
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Watchlist', () {
    test('should return a success message when saving succeeds', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(any),
      ).thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testMovieDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return a DatabaseFailure when saving fails', () async {
      when(
        mockLocalDataSource.insertWatchlist(any),
      ).thenThrow(const DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlist(testMovieDetail);
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });

    test('should return a success message when removing succeeds', () async {
      when(
        mockLocalDataSource.removeWatchlist(any),
      ).thenAnswer((_) async => 'Removed from Watchlist');
      final result = await repository.removeWatchlist(testMovieDetail);
      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return a DatabaseFailure when removing fails', () async {
      when(
        mockLocalDataSource.removeWatchlist(any),
      ).thenThrow(const DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlist(testMovieDetail);
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });

    test('should return the watchlist status of a movie', () async {
      // arrange
      when(mockLocalDataSource.getMovieById(1)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(1);
      // assert
      expect(result, false);

      // arrange
      when(
        mockLocalDataSource.getMovieById(1),
      ).thenAnswer((_) async => testMovieTable);
      // act
      final addedResult = await repository.isAddedToWatchlist(1);
      // assert
      expect(addedResult, true);
    });

    test('should return the list of movies stored on the watchlist', () async {
      // arrange
      when(
        mockLocalDataSource.getWatchlistMovies(),
      ).thenAnswer((_) async => <MovieTable>[testMovieTable]);
      // act
      final result = await repository.getWatchlistMovies();
      // assert
      expect(result.getOrElse(() => []), [testWatchlistMovie]);
    });
  });
}
