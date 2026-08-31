import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should be a subclass of TvSeries entity', () {
    final result = testTvSeriesModel.toEntity();
    expect(result, testTvSeries);
  });

  test('should return a JSON map containing proper data', () {
    final result = testTvSeriesModel.toJson();
    final expectedJsonMap = {
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
    };
    expect(result, expectedJsonMap);
  });
}
