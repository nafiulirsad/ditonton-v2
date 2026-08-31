import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should return a valid model when the JSON is valid', () {
    // arrange
    final jsonMap = {
      'air_date': '2020-05-05',
      'episode_number': 1,
      'id': 1,
      'name': 'Episode 1',
      'overview': 'Overview',
      'runtime': 45,
      'season_number': 1,
      'still_path': '/path.jpg',
      'vote_average': 1.0,
      'vote_count': 1,
    };
    // act
    final result = EpisodeModel.fromJson(jsonMap);
    // assert
    expect(result, testEpisodeModel);
  });

  test('should return a JSON map containing proper data', () {
    final result = testEpisodeModel.toJson();
    expect(result, {
      'air_date': '2020-05-05',
      'episode_number': 1,
      'id': 1,
      'name': 'Episode 1',
      'overview': 'Overview',
      'runtime': 45,
      'season_number': 1,
      'still_path': '/path.jpg',
      'vote_average': 1.0,
      'vote_count': 1,
    });
  });

  test('should convert the model into an Episode entity', () {
    final result = testEpisodeModel.toEntity();
    expect(result, testEpisode);
  });
}
