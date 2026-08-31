import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  final testTvSeriesResponseModel = TvSeriesResponse(
    tvSeriesList: testTvSeriesModelList,
  );

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_on_the_air.json'),
      );
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, testTvSeriesResponseModel);
    });

    test('should drop items that do not have a poster path', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'results': [
          {
            'backdrop_path': '/path.jpg',
            'first_air_date': '2020-05-05',
            'genre_ids': [1],
            'id': 2,
            'name': 'Name',
            'original_name': 'Original Name',
            'overview': 'Overview',
            'popularity': 1.0,
            'poster_path': null,
            'vote_average': 1.0,
            'vote_count': 1,
          },
        ],
      };
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result.tvSeriesList, isEmpty);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      // act
      final result = testTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        'results': [
          {
            'backdrop_path': '/path.jpg',
            'first_air_date': '2020-05-05',
            'genre_ids': [1, 2, 3, 4],
            'id': 1,
            'name': 'Name',
            'original_name': 'Original Name',
            'overview': 'Overview',
            'popularity': 1.0,
            'poster_path': '/path.jpg',
            'vote_average': 1.0,
            'vote_count': 1,
          },
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
