import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should be a subclass of Movie entity', () {
    final result = testMovieModel.toEntity();
    expect(result, testMovieFromModel);
  });

  test('should return a JSON map containing proper data', () {
    final result = testMovieModel.toJson();
    final expectedJsonMap = {
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
    };
    expect(result, expectedJsonMap);
  });

  test('should return a valid model from JSON', () {
    final result = testMovieModel.toJson();
    expect(result['id'], 1);
    expect(result['title'], 'Title');
  });
}
