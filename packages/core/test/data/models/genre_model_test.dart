import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testGenreModel = GenreModel(id: 1, name: 'Action');

  test('should return a valid model when the JSON is valid', () {
    final result = GenreModel.fromJson({'id': 1, 'name': 'Action'});
    expect(result, testGenreModel);
  });

  test('should return a JSON map containing proper data', () {
    final result = testGenreModel.toJson();
    expect(result, {'id': 1, 'name': 'Action'});
  });

  test('should convert the model into a Genre entity', () {
    final result = testGenreModel.toEntity();
    expect(result, const Genre(id: 1, name: 'Action'));
  });
}
