import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<bool> _tableExists(Database db, String table) async {
  final result = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
    [table],
  );
  return result.isNotEmpty;
}

/// Baris watchlist yang dipakai pengujian. Modul core menerima map sehingga
/// tidak perlu mengenal model milik modul fitur.
const testMovieMap = <String, dynamic>{
  'id': 1,
  'title': 'title',
  'overview': 'overview',
  'posterPath': 'posterPath',
};

const testTvSeriesMap = <String, dynamic>{
  'id': 1,
  'name': 'Name',
  'overview': 'Overview',
  'posterPath': '/path.jpg',
};

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Pastikan setiap eksekusi tes berangkat dari basis data yang bersih.
    final path = '${await getDatabasesPath()}/ditonton.db';
    await databaseFactory.deleteDatabase(path);
  });

  setUp(() {
    databaseHelper = DatabaseHelper();
  });

  group('schema', () {
    test('onCreate should create both watchlist tables', () async {
      // arrange
      final db = await databaseFactory.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: DatabaseHelper.databaseVersion,
          onCreate: DatabaseHelper.onCreate,
        ),
      );
      // assert
      expect(await _tableExists(db, DatabaseHelper.tblWatchlist), true);
      expect(await _tableExists(db, DatabaseHelper.tblWatchlistTvSeries), true);
      await db.close();
    });

    test(
      'onUpgrade should add the tv series table for older databases',
      () async {
        // arrange: basis data versi 1 hanya memiliki tabel watchlist film.
        final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
        await db.execute('''
        CREATE TABLE ${DatabaseHelper.tblWatchlist} (
          id INTEGER PRIMARY KEY,
          title TEXT,
          overview TEXT,
          posterPath TEXT
        );
      ''');
        // act
        await DatabaseHelper.onUpgrade(db, 1, DatabaseHelper.databaseVersion);
        // assert
        expect(
          await _tableExists(db, DatabaseHelper.tblWatchlistTvSeries),
          true,
        );
        await db.close();
      },
    );

    test(
      'onUpgrade should do nothing when the database is already current',
      () async {
        // arrange
        final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
        // act
        await DatabaseHelper.onUpgrade(db, 2, DatabaseHelper.databaseVersion);
        // assert
        expect(
          await _tableExists(db, DatabaseHelper.tblWatchlistTvSeries),
          false,
        );
        await db.close();
      },
    );
  });

  group('movie watchlist', () {
    test('should insert, read, and remove a movie', () async {
      // act
      final insertResult = await databaseHelper.insertWatchlist(testMovieMap);
      final movie = await databaseHelper.getMovieById(1);
      final movies = await databaseHelper.getWatchlistMovies();
      // assert
      expect(insertResult, 1);
      expect(movie?['title'], testMovieMap['title']);
      expect(movies.length, 1);

      // act
      final removeResult = await databaseHelper.removeWatchlist(1);
      // assert
      expect(removeResult, 1);
      expect(await databaseHelper.getMovieById(1), null);
      expect(await databaseHelper.getWatchlistMovies(), isEmpty);
    });
  });

  group('tv series watchlist', () {
    test('should insert, read, and remove a tv series', () async {
      // act
      final insertResult = await databaseHelper.insertTvSeriesWatchlist(
        testTvSeriesMap,
      );
      final tvSeries = await databaseHelper.getTvSeriesById(1);
      final tvSeriesList = await databaseHelper.getWatchlistTvSeries();
      // assert
      expect(insertResult, 1);
      expect(tvSeries?['name'], testTvSeriesMap['name']);
      expect(tvSeriesList.length, 1);

      // act
      final removeResult = await databaseHelper.removeTvSeriesWatchlist(1);
      // assert
      expect(removeResult, 1);
      expect(await databaseHelper.getTvSeriesById(1), null);
      expect(await databaseHelper.getWatchlistTvSeries(), isEmpty);
    });
  });
}
