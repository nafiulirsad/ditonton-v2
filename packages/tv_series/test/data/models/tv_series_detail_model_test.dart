import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  test('should return a valid model when the JSON is valid', () {
    // arrange
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('dummy_data/tv_detail.json'),
    );
    // act
    final result = TvSeriesDetailResponse.fromJson(jsonMap);
    // assert
    expect(result, testTvSeriesDetailResponse);
  });

  test('should return a JSON map containing proper data', () {
    // act
    final result = testTvSeriesDetailResponse.toJson();
    // assert
    expect(result['id'], 1);
    expect(result['name'], 'Name');
    expect(result['number_of_seasons'], 1);
    expect(result['genres'], [
      {'id': 1, 'name': 'Action'},
    ]);
    expect(result['seasons'], [
      {
        'air_date': '2020-05-05',
        'episode_count': 10,
        'id': 1,
        'name': 'Season 1',
        'overview': 'Overview',
        'poster_path': '/path.jpg',
        'season_number': 1,
      },
    ]);
  });

  test('should convert the response into a TvSeriesDetail entity', () {
    // act
    final result = testTvSeriesDetailResponse.toEntity();
    // assert
    expect(result, testTvSeriesDetail);
  });
}
