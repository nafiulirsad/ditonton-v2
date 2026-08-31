import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

import '../../json_reader.dart';

void main() {
  const testMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    budget: 100,
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'https://google.com',
    id: 1,
    imdbId: 'imdb1',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    revenue: 12000,
    runtime: 120,
    status: 'Status',
    tagline: 'Tagline',
    title: 'Title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should return a valid model when the JSON is valid', () {
    // arrange
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('dummy_data/movie_detail.json'),
    );
    // act
    final result = MovieDetailResponse.fromJson(jsonMap);
    // assert
    expect(result, testMovieDetailResponse);
  });

  test('should return a JSON map containing proper data', () {
    // act
    final result = testMovieDetailResponse.toJson();
    // assert
    expect(result['id'], 1);
    expect(result['title'], 'Title');
    expect(result['genres'], [
      {'id': 1, 'name': 'Action'},
    ]);
  });

  test('should convert the response into a MovieDetail entity', () {
    // act
    final result = testMovieDetailResponse.toEntity();
    // assert
    expect(
      result,
      const MovieDetail(
        adult: false,
        backdropPath: '/path.jpg',
        genres: [Genre(id: 1, name: 'Action')],
        id: 1,
        originalTitle: 'Original Title',
        overview: 'Overview',
        posterPath: '/path.jpg',
        releaseDate: '2020-05-05',
        runtime: 120,
        title: 'Title',
        voteAverage: 1.0,
        voteCount: 1,
      ),
    );
  });
}
