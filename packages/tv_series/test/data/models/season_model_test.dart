import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should return a valid model when the JSON is valid', () {
    // arrange
    final jsonMap = {
      'air_date': '2020-05-05',
      'episode_count': 10,
      'id': 1,
      'name': 'Season 1',
      'overview': 'Overview',
      'poster_path': '/path.jpg',
      'season_number': 1,
    };
    // act
    final result = SeasonModel.fromJson(jsonMap);
    // assert
    expect(result, testSeasonModel);
  });

  test('should return a JSON map containing proper data', () {
    final result = testSeasonModel.toJson();
    expect(result, {
      'air_date': '2020-05-05',
      'episode_count': 10,
      'id': 1,
      'name': 'Season 1',
      'overview': 'Overview',
      'poster_path': '/path.jpg',
      'season_number': 1,
    });
  });

  test('should convert the model into a Season entity', () {
    final result = testSeasonModel.toEntity();
    expect(result, testSeason);
  });
}
