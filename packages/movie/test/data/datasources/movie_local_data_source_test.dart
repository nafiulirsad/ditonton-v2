import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return a success message when the insert succeeds', () async {
      // arrange
      when(
        mockDatabaseHelper.insertWatchlist(testMovieTable.toJson()),
      ).thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlist(testMovieTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw a DatabaseException when the insert fails', () async {
      // arrange
      when(
        mockDatabaseHelper.insertWatchlist(testMovieTable.toJson()),
      ).thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlist(testMovieTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return a success message when the removal succeeds', () async {
      when(
        mockDatabaseHelper.removeWatchlist(testMovieTable.id),
      ).thenAnswer((_) async => 1);
      final result = await dataSource.removeWatchlist(testMovieTable);
      expect(result, 'Removed from Watchlist');
    });

    test('should throw a DatabaseException when the removal fails', () async {
      when(
        mockDatabaseHelper.removeWatchlist(testMovieTable.id),
      ).thenThrow(Exception());
      final call = dataSource.removeWatchlist(testMovieTable);
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get movie detail by id', () {
    const tId = 1;

    test('should return a movie table when the data is found', () async {
      when(
        mockDatabaseHelper.getMovieById(tId),
      ).thenAnswer((_) async => testMovieMap);
      final result = await dataSource.getMovieById(tId);
      expect(result, testMovieTable);
    });

    test('should return null when the data is not found', () async {
      when(mockDatabaseHelper.getMovieById(tId)).thenAnswer((_) async => null);
      final result = await dataSource.getMovieById(tId);
      expect(result, null);
    });
  });

  group('get watchlist movies', () {
    test('should return a list of MovieTable from the database', () async {
      when(
        mockDatabaseHelper.getWatchlistMovies(),
      ).thenAnswer((_) async => [testMovieMap]);
      final result = await dataSource.getWatchlistMovies();
      expect(result, [testMovieTable]);
    });
  });
}
