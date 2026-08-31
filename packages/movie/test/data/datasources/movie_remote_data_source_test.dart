import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = TmdbApi.apiKey;
  const baseUrl = TmdbApi.baseUrl;

  late MovieRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
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

  group('get Now Playing Movies', () {
    final url = '$baseUrl/movie/now_playing?$apiKey';

    test(
      'should return a list of movies when the response code is 200',
      () async {
        // arrange
        arrangeSuccess(url, 'now_playing.json');
        // act
        final result = await dataSource.getNowPlayingMovies();
        // assert
        expect(result, testMovieModelList);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        // arrange
        arrangeFailure(url);
        // act
        final call = dataSource.getNowPlayingMovies();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular Movies', () {
    final url = '$baseUrl/movie/popular?$apiKey';

    test(
      'should return a list of movies when the response code is 200',
      () async {
        arrangeSuccess(url, 'popular.json');
        final result = await dataSource.getPopularMovies();
        expect(result, isNotEmpty);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.getPopularMovies();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated Movies', () {
    final url = '$baseUrl/movie/top_rated?$apiKey';

    test(
      'should return a list of movies when the response code is 200',
      () async {
        arrangeSuccess(url, 'top_rated.json');
        final result = await dataSource.getTopRatedMovies();
        expect(result, isNotEmpty);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.getTopRatedMovies();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get movie detail', () {
    const tId = 1;
    final url = '$baseUrl/movie/$tId?$apiKey';

    test(
      'should return a movie detail when the response code is 200',
      () async {
        arrangeSuccess(url, 'movie_detail.json');
        final result = await dataSource.getMovieDetail(tId);
        expect(result.id, tId);
        expect(result.title, 'Title');
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.getMovieDetail(tId);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get movie recommendations', () {
    const tId = 1;
    final url = '$baseUrl/movie/$tId/recommendations?$apiKey';

    test(
      'should return a list of movies when the response code is 200',
      () async {
        arrangeSuccess(url, 'movie_recommendations.json');
        final result = await dataSource.getMovieRecommendations(tId);
        expect(result, isNotEmpty);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.getMovieRecommendations(tId);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search movies', () {
    const tQuery = 'Spiderman';
    final url = '$baseUrl/search/movie?$apiKey&query=$tQuery';

    test(
      'should return a list of movies when the response code is 200',
      () async {
        arrangeSuccess(url, 'search_spiderman_movie.json');
        final result = await dataSource.searchMovies(tQuery);
        expect(result, isNotEmpty);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        arrangeFailure(url);
        final call = dataSource.searchMovies(tQuery);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
