import 'dart:convert';

import 'package:core/core.dart';

import '../models/season_detail_model.dart';
import '../models/tv_series_detail_model.dart';
import '../models/tv_series_model.dart';
import '../models/tv_series_response.dart';

import 'package:http/http.dart' as http;

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getOnTheAirTvSeries();
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
  Future<SeasonDetailResponse> getSeasonDetail(int id, int seasonNumber);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  final http.Client client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getOnTheAirTvSeries() =>
      _getTvSeriesList('${TmdbApi.baseUrl}/tv/on_the_air?${TmdbApi.apiKey}');

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() =>
      _getTvSeriesList('${TmdbApi.baseUrl}/tv/popular?${TmdbApi.apiKey}');

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() =>
      _getTvSeriesList('${TmdbApi.baseUrl}/tv/top_rated?${TmdbApi.apiKey}');

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) =>
      _getTvSeriesList(
        '${TmdbApi.baseUrl}/tv/$id/recommendations?${TmdbApi.apiKey}',
      );

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) => _getTvSeriesList(
    '${TmdbApi.baseUrl}/search/tv?${TmdbApi.apiKey}&query=$query',
  );

  @override
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id) async {
    final response = await client.get(
      Uri.parse('${TmdbApi.baseUrl}/tv/$id?${TmdbApi.apiKey}'),
    );

    if (response.statusCode == 200) {
      return TvSeriesDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SeasonDetailResponse> getSeasonDetail(int id, int seasonNumber) async {
    final response = await client.get(
      Uri.parse(
        '${TmdbApi.baseUrl}/tv/$id/season/$seasonNumber?${TmdbApi.apiKey}',
      ),
    );

    if (response.statusCode == 200) {
      return SeasonDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<List<TvSeriesModel>> _getTvSeriesList(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }
}
