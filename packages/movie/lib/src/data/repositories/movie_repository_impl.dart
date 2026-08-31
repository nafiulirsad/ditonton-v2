import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_model.dart';
import '../models/movie_table.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() =>
      _fetchMovies(remoteDataSource.getNowPlayingMovies);

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() =>
      _fetchMovies(remoteDataSource.getPopularMovies);

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() =>
      _fetchMovies(remoteDataSource.getTopRatedMovies);

  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) =>
      _fetchMovies(() => remoteDataSource.getMovieRecommendations(id));

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) =>
      _fetchMovies(() => remoteDataSource.searchMovies(query));

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async {
    try {
      final result = await remoteDataSource.getMovieDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure(kConnectionFailureMessage));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async {
    try {
      final result = await localDataSource.insertWatchlist(
        MovieTable.fromEntity(movie),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async {
    try {
      final result = await localDataSource.removeWatchlist(
        MovieTable.fromEntity(movie),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getMovieById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async {
    final result = await localDataSource.getWatchlistMovies();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  Future<Either<Failure, List<Movie>>> _fetchMovies(
    Future<List<MovieModel>> Function() request,
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
