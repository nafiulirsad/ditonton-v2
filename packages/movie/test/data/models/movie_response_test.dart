import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  final testMovieResponseModel = MovieResponse(movieList: testMovieModelList);

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/now_playing.json'),
      );
      // act
      final result = MovieResponse.fromJson(jsonMap);
      // assert
      expect(result, testMovieResponseModel);
    });

    test('should drop items that do not have a poster path', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'results': [
          {
            'adult': false,
            'backdrop_path': '/path.jpg',
            'genre_ids': [1],
            'id': 2,
            'original_title': 'Original Title',
            'overview': 'Overview',
            'popularity': 1.0,
            'poster_path': null,
            'release_date': '2020-05-05',
            'title': 'Title',
            'video': false,
            'vote_average': 1.0,
            'vote_count': 1,
          },
        ],
      };
      // act
      final result = MovieResponse.fromJson(jsonMap);
      // assert
      expect(result.movieList, isEmpty);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      // act
      final result = testMovieResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        'results': [
          {
            'adult': false,
            'backdrop_path': '/path.jpg',
            'genre_ids': [1, 2, 3, 4],
            'id': 1,
            'original_title': 'Original Title',
            'overview': 'Overview',
            'popularity': 1.0,
            'poster_path': '/path.jpg',
            'release_date': '2020-05-05',
            'title': 'Title',
            'video': false,
            'vote_average': 1.0,
            'vote_count': 1,
          },
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
