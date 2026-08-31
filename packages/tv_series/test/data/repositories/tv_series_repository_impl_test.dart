import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  /// Menjalankan skenario sukses, ServerException, dan SocketException untuk
  /// setiap metode repository yang mengembalikan daftar serial TV.
  void testTvSeriesListMethod({
    required String description,
    required Future<List<dynamic>> Function() stubTarget,
    required Future<Either<Failure, List<TvSeries>>> Function() act,
  }) {
    group(description, () {
      test(
        'should return a list of tv series when the call is successful',
        () async {
          // arrange
          when(stubTarget()).thenAnswer((_) async => testTvSeriesModelList);
          // act
          final result = await act();
          // assert
          expect(result.getOrElse(() => []), testTvSeriesList);
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

  testTvSeriesListMethod(
    description: 'On The Air TV Series',
    stubTarget: () => mockRemoteDataSource.getOnTheAirTvSeries(),
    act: () => repository.getOnTheAirTvSeries(),
  );

  testTvSeriesListMethod(
    description: 'Popular TV Series',
    stubTarget: () => mockRemoteDataSource.getPopularTvSeries(),
    act: () => repository.getPopularTvSeries(),
  );

  testTvSeriesListMethod(
    description: 'Top Rated TV Series',
    stubTarget: () => mockRemoteDataSource.getTopRatedTvSeries(),
    act: () => repository.getTopRatedTvSeries(),
  );

  testTvSeriesListMethod(
    description: 'TV Series Recommendations',
    stubTarget: () => mockRemoteDataSource.getTvSeriesRecommendations(1),
    act: () => repository.getTvSeriesRecommendations(1),
  );

  testTvSeriesListMethod(
    description: 'Search TV Series',
    stubTarget: () => mockRemoteDataSource.searchTvSeries('game of thrones'),
    act: () => repository.searchTvSeries('game of thrones'),
  );

  group('Get TV Series Detail', () {
    const tId = 1;

    test(
      'should return a tv series detail when the call is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenAnswer((_) async => testTvSeriesDetailResponse);
        // act
        final result = await repository.getTvSeriesDetail(tId);
        // assert
        expect(result, const Right(testTvSeriesDetail));
      },
    );

    test(
      'should return a ServerFailure when the call is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenThrow(ServerException());
        final result = await repository.getTvSeriesDetail(tId);
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return a ConnectionFailure when the device is offline',
      () async {
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenThrow(const SocketException('Failed to connect'));
        final result = await repository.getTvSeriesDetail(tId);
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get Season Detail', () {
    const tId = 1;
    const tSeasonNumber = 1;

    test('should return a season detail when the call is successful', () async {
      // arrange
      when(
        mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber),
      ).thenAnswer((_) async => testSeasonDetailResponse);
      // act
      final result = await repository.getSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(result, const Right(testSeasonDetail));
    });

    test(
      'should return a ServerFailure when the call is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber),
        ).thenThrow(ServerException());
        final result = await repository.getSeasonDetail(tId, tSeasonNumber);
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return a ConnectionFailure when the device is offline',
      () async {
        when(
          mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber),
        ).thenThrow(const SocketException('Failed to connect'));
        final result = await repository.getSeasonDetail(tId, tSeasonNumber);
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Watchlist', () {
    test('should return a success message when saving succeeds', () async {
      when(
        mockLocalDataSource.insertWatchlist(any),
      ).thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return a DatabaseFailure when saving fails', () async {
      when(
        mockLocalDataSource.insertWatchlist(any),
      ).thenThrow(const DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });

    test('should return a success message when removing succeeds', () async {
      when(
        mockLocalDataSource.removeWatchlist(any),
      ).thenAnswer((_) async => 'Removed from Watchlist');
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return a DatabaseFailure when removing fails', () async {
      when(
        mockLocalDataSource.removeWatchlist(any),
      ).thenThrow(const DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });

    test('should return the watchlist status of a tv series', () async {
      // arrange
      when(
        mockLocalDataSource.getTvSeriesById(1),
      ).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(1);
      // assert
      expect(result, false);

      // arrange
      when(
        mockLocalDataSource.getTvSeriesById(1),
      ).thenAnswer((_) async => testTvSeriesTable);
      // act
      final addedResult = await repository.isAddedToWatchlist(1);
      // assert
      expect(addedResult, true);
    });

    test(
      'should return the list of tv series stored on the watchlist',
      () async {
        // arrange
        when(
          mockLocalDataSource.getWatchlistTvSeries(),
        ).thenAnswer((_) async => <TvSeriesTable>[testTvSeriesTable]);
        // act
        final result = await repository.getWatchlistTvSeries();
        // assert
        expect(result.getOrElse(() => []), [testWatchlistTvSeries]);
      },
    );
  });
}
