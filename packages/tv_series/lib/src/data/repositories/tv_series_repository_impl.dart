import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/season_detail.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tv_series_detail.dart';
import '../../domain/repositories/tv_series_repository.dart';
import '../datasources/tv_series_local_data_source.dart';
import '../datasources/tv_series_remote_data_source.dart';
import '../models/tv_series_model.dart';
import '../models/tv_series_table.dart';

class TvSeriesRepositoryImpl implements TvSeriesRepository {
  final TvSeriesRemoteDataSource remoteDataSource;
  final TvSeriesLocalDataSource localDataSource;

  TvSeriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TvSeries>>> getOnTheAirTvSeries() =>
      _fetchTvSeries(remoteDataSource.getOnTheAirTvSeries);

  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() =>
      _fetchTvSeries(remoteDataSource.getPopularTvSeries);

  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() =>
      _fetchTvSeries(remoteDataSource.getTopRatedTvSeries);

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id) =>
      _fetchTvSeries(() => remoteDataSource.getTvSeriesRecommendations(id));

  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) =>
      _fetchTvSeries(() => remoteDataSource.searchTvSeries(query));

  @override
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(kConnectionFailureMessage));
    }
  }

  @override
  Future<Either<Failure, SeasonDetail>> getSeasonDetail(
    int id,
    int seasonNumber,
  ) async {
    try {
      final result = await remoteDataSource.getSeasonDetail(id, seasonNumber);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(kConnectionFailureMessage));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvSeriesDetail tvSeries) async {
    try {
      final result = await localDataSource.insertWatchlist(
        TvSeriesTable.fromEntity(tvSeries),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(
    TvSeriesDetail tvSeries,
  ) async {
    try {
      final result = await localDataSource.removeWatchlist(
        TvSeriesTable.fromEntity(tvSeries),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTvSeriesById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() async {
    final result = await localDataSource.getWatchlistTvSeries();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  Future<Either<Failure, List<TvSeries>>> _fetchTvSeries(
    Future<List<TvSeriesModel>> Function() request,
  ) async {
    try {
      final result = await request();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(kConnectionFailureMessage));
    }
  }
}
