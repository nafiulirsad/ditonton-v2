import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should build a table from a MovieDetail entity', () {
    final result = MovieTable.fromEntity(testMovieDetail);
    expect(result.id, testMovieDetail.id);
    expect(result.title, testMovieDetail.title);
    expect(result.posterPath, testMovieDetail.posterPath);
    expect(result.overview, testMovieDetail.overview);
  });

  test('should build a table from a database map', () {
    final result = MovieTable.fromMap(testMovieMap);
    expect(result, testMovieTable);
  });

  test('should return a JSON map containing proper data', () {
    final result = testMovieTable.toJson();
    expect(result, testMovieMap);
  });

  test('should convert the table into a Movie entity', () {
    final result = testMovieTable.toEntity();
    expect(result, testWatchlistMovie);
  });
}
