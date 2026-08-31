import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvSeriesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('save watchlist', () {
    test('should return a success message when the insert succeeds', () async {
      when(
        mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable.toJson()),
      ).thenAnswer((_) async => 1);
      final result = await dataSource.insertWatchlist(testTvSeriesTable);
      expect(result, 'Added to Watchlist');
    });

    test('should throw a DatabaseException when the insert fails', () async {
      when(
        mockDatabaseHelper.insertTvSeriesWatchlist(testTvSeriesTable.toJson()),
      ).thenThrow(Exception());
      final call = dataSource.insertWatchlist(testTvSeriesTable);
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return a success message when the removal succeeds', () async {
      when(
        mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable.id),
      ).thenAnswer((_) async => 1);
      final result = await dataSource.removeWatchlist(testTvSeriesTable);
      expect(result, 'Removed from Watchlist');
    });

    test('should throw a DatabaseException when the removal fails', () async {
      when(
        mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable.id),
      ).thenThrow(Exception());
      final call = dataSource.removeWatchlist(testTvSeriesTable);
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get tv series detail by id', () {
    const tId = 1;

    test('should return a tv series table when the data is found', () async {
      when(
        mockDatabaseHelper.getTvSeriesById(tId),
      ).thenAnswer((_) async => testTvSeriesMap);
      final result = await dataSource.getTvSeriesById(tId);
      expect(result, testTvSeriesTable);
    });

    test('should return null when the data is not found', () async {
      when(
        mockDatabaseHelper.getTvSeriesById(tId),
      ).thenAnswer((_) async => null);
      final result = await dataSource.getTvSeriesById(tId);
      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return a list of TvSeriesTable from the database', () async {
      when(
        mockDatabaseHelper.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [testTvSeriesMap]);
      final result = await dataSource.getWatchlistTvSeries();
      expect(result, [testTvSeriesTable]);
    });
  });
}
