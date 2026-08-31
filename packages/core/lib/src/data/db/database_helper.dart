import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

/// Membungkus akses ke basis data SQLite untuk kebutuhan watchlist.
class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const int databaseVersion = 2;
  static const String tblWatchlist = 'watchlist';
  static const String tblWatchlistTvSeries = 'watchlist_tv_series';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    return openDatabase(
      databasePath,
      version: databaseVersion,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
    );
  }

  /// Membuat skema awal basis data.
  @visibleForTesting
  static Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await _createTvSeriesTable(db);
  }

  /// Menambahkan tabel watchlist TV series bagi pengguna versi lama.
  @visibleForTesting
  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await _createTvSeriesTable(db);
    }
  }

  static Future<void> _createTvSeriesTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tblWatchlistTvSeries (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  /// Menyimpan satu baris watchlist film. [movie] merupakan hasil `toJson()`
  /// dari model pada modul movie sehingga modul core tidak perlu bergantung
  /// pada model milik fitur.
  Future<int> insertWatchlist(Map<String, dynamic> movie) async {
    final db = await database;
    return db!.insert(tblWatchlist, movie);
  }

  Future<int> removeWatchlist(int id) async {
    final db = await database;
    return db!.delete(tblWatchlist, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    return db!.query(tblWatchlist);
  }

  /// Menyimpan satu baris watchlist serial TV dalam bentuk map.
  Future<int> insertTvSeriesWatchlist(Map<String, dynamic> tvSeries) async {
    final db = await database;
    return db!.insert(tblWatchlistTvSeries, tvSeries);
  }

  Future<int> removeTvSeriesWatchlist(int id) async {
    final db = await database;
    return db!.delete(tblWatchlistTvSeries, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getTvSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      tblWatchlistTvSeries,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
    final db = await database;
    return db!.query(tblWatchlistTvSeries);
  }
}
