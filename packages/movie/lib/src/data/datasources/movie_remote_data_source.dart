import 'dart:convert';

import 'package:core/core.dart';

import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';
import '../models/movie_response.dart';

import 'package:http/http.dart' as http;

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() =>
      _getMovieList('${TmdbApi.baseUrl}/movie/now_playing?${TmdbApi.apiKey}');

  @override
  Future<List<MovieModel>> getPopularMovies() =>
      _getMovieList('${TmdbApi.baseUrl}/movie/popular?${TmdbApi.apiKey}');

  @override
  Future<List<MovieModel>> getTopRatedMovies() =>
      _getMovieList('${TmdbApi.baseUrl}/movie/top_rated?${TmdbApi.apiKey}');

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) => _getMovieList(
    '${TmdbApi.baseUrl}/movie/$id/recommendations?${TmdbApi.apiKey}',
  );

  @override
  Future<List<MovieModel>> searchMovies(String query) => _getMovieList(
    '${TmdbApi.baseUrl}/search/movie?${TmdbApi.apiKey}&query=$query',
  );

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response = await client.get(
      Uri.parse('${TmdbApi.baseUrl}/movie/$id?${TmdbApi.apiKey}'),
    );

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<List<MovieModel>> _getMovieList(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }
}
