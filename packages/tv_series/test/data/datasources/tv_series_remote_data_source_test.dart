import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = TmdbApi.apiKey;
  const baseUrl = TmdbApi.baseUrl;

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  void arrangeSuccess(String url, String fixture) {
    when(mockHttpClient.get(Uri.parse(url))).thenAnswer(
      (_) async => http.Response(readJson('dummy_data/$fixture'), 200),
    );
  }

  void arrangeFailure(String url) {
    when(
      mockHttpClient.get(Uri.parse(url)),
    ).thenAnswer((_) async => http.Response('Not Found', 404));
  }

  group('get On The Air TV Series', () {
    final url = '$baseUrl/tv/on_the_air?$apiKey';

    test(
      'should return a list of tv series when the response code is 200',
      () async {
        arrangeSuccess(url, 'tv_on_the_air.json');
        final result = await dataSource.getOnTheAirTvSeries();
        expect(result, testTvSeriesModelList);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.getOnTheAirTvSeries();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular TV Series', () {
    final url = '$baseUrl/tv/popular?$apiKey';

    test(
      'should return a list of tv series when the response code is 200',
      () async {
        arrangeSuccess(url, 'tv_popular.json');
        final result = await dataSource.getPopularTvSeries();
        expect(result, testTvSeriesModelList);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.getPopularTvSeries();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated TV Series', () {
    final url = '$baseUrl/tv/top_rated?$apiKey';

    test(
      'should return a list of tv series when the response code is 200',
      () async {
        arrangeSuccess(url, 'tv_top_rated.json');
        final result = await dataSource.getTopRatedTvSeries();
        expect(result, testTvSeriesModelList);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.getTopRatedTvSeries();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv series detail', () {
    const tId = 1;
    final url = '$baseUrl/tv/$tId?$apiKey';

    test(
      'should return a tv series detail when the response code is 200',
      () async {
        arrangeSuccess(url, 'tv_detail.json');
        final result = await dataSource.getTvSeriesDetail(tId);
        expect(result, testTvSeriesDetailResponse);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.getTvSeriesDetail(tId);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv series recommendations', () {
    const tId = 1;
    final url = '$baseUrl/tv/$tId/recommendations?$apiKey';

    test(
      'should return a list of tv series when the response code is 200',
      () async {
        arrangeSuccess(url, 'tv_recommendations.json');
        final result = await dataSource.getTvSeriesRecommendations(tId);
        expect(result, testTvSeriesModelList);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.getTvSeriesRecommendations(tId);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search tv series', () {
    const tQuery = 'Game of Thrones';
    final url = '$baseUrl/search/tv?$apiKey&query=$tQuery';

    test(
      'should return a list of tv series when the response code is 200',
      () async {
        arrangeSuccess(url, 'search_tv_series.json');
        final result = await dataSource.searchTvSeries(tQuery);
        expect(result, testTvSeriesModelList);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.searchTvSeries(tQuery);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get season detail', () {
    const tId = 1;
    const tSeasonNumber = 1;
    final url = '$baseUrl/tv/$tId/season/$tSeasonNumber?$apiKey';

    test(
      'should return a season detail when the response code is 200',
      () async {
        arrangeSuccess(url, 'season_detail.json');
        final result = await dataSource.getSeasonDetail(tId, tSeasonNumber);
        expect(result, testSeasonDetailResponse);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.getSeasonDetail(tId, tSeasonNumber);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
