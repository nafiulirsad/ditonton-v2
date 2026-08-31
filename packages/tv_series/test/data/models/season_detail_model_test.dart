import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  test('should return a valid model when the JSON is valid', () {
    // arrange
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('dummy_data/season_detail.json'),
    );
    // act
    final result = SeasonDetailResponse.fromJson(jsonMap);
    // assert
    expect(result, testSeasonDetailResponse);
  });

  test('should return a JSON map containing proper data', () {
    // act
    final result = testSeasonDetailResponse.toJson();
    // assert
    expect(result['id'], 1);
    expect(result['name'], 'Season 1');
    expect(result['season_number'], 1);
    expect((result['episodes'] as List).length, 1);
  });

  test('should convert the response into a SeasonDetail entity', () {
    // act
    final result = testSeasonDetailResponse.toEntity();
    // assert
    expect(result, testSeasonDetail);
  });
}
