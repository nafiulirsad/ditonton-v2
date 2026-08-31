import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should build a table from a TvSeriesDetail entity', () {
    final result = TvSeriesTable.fromEntity(testTvSeriesDetail);
    expect(result.id, testTvSeriesDetail.id);
    expect(result.name, testTvSeriesDetail.name);
    expect(result.posterPath, testTvSeriesDetail.posterPath);
    expect(result.overview, testTvSeriesDetail.overview);
  });

  test('should build a table from a database map', () {
    final result = TvSeriesTable.fromMap(testTvSeriesMap);
    expect(result, testTvSeriesTable);
  });

  test('should return a JSON map containing proper data', () {
    final result = testTvSeriesTable.toJson();
    expect(result, testTvSeriesMap);
  });

  test('should convert the table into a TvSeries entity', () {
    final result = testTvSeriesTable.toEntity();
    expect(result, testWatchlistTvSeries);
  });
}
