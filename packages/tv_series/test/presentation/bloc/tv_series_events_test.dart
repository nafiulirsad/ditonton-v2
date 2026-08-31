import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('events without payload should be equal', () {
    expect(const FetchOnTheAirTvSeries(), const FetchOnTheAirTvSeries());
    expect(const FetchPopularTvSeries(), const FetchPopularTvSeries());
    expect(const FetchTopRatedTvSeries(), const FetchTopRatedTvSeries());
    expect(const FetchWatchlistTvSeries(), const FetchWatchlistTvSeries());
    expect(const FetchOnTheAirTvSeries().props, isEmpty);
    expect(const FetchPopularTvSeries().props, isEmpty);
    expect(const FetchTopRatedTvSeries().props, isEmpty);
    expect(const FetchWatchlistTvSeries().props, isEmpty);
  });

  test('events with payload should compare their payload', () {
    expect(const FetchTvSeriesDetail(1), const FetchTvSeriesDetail(1));
    expect(const FetchTvSeriesDetail(1), isNot(const FetchTvSeriesDetail(2)));
    expect(const FetchTvSeriesRecommendations(1).props, [1]);
    expect(const OnTvSeriesQueryChanged('a').props, ['a']);
    expect(const LoadWatchlistTvSeriesStatus(1).props, [1]);
    expect(const AddTvSeriesToWatchlist(testTvSeriesDetail).props, [
      testTvSeriesDetail,
    ]);
    expect(const RemoveTvSeriesFromWatchlist(testTvSeriesDetail).props, [
      testTvSeriesDetail,
    ]);
    expect(const FetchSeasonDetail(id: 1, seasonNumber: 2).props, [1, 2]);
  });

  test('states should compare their payload', () {
    expect(const TvSeriesListEmpty(), const TvSeriesListEmpty());
    expect(const TvSeriesListLoading(), const TvSeriesListLoading());
    expect(TvSeriesListHasData(testTvSeriesList).props, [testTvSeriesList]);
    expect(const TvSeriesListError('a').props, ['a']);
    expect(const TvSeriesDetailEmpty().props, isEmpty);
    expect(const TvSeriesDetailLoading().props, isEmpty);
    expect(const TvSeriesListEmpty().props, isEmpty);
    expect(const TvSeriesListLoading().props, isEmpty);
    expect(const SeasonDetailEmpty().props, isEmpty);
    expect(const SeasonDetailLoading().props, isEmpty);
    expect(const TvSeriesDetailEmpty(), const TvSeriesDetailEmpty());
    expect(const TvSeriesDetailLoading(), const TvSeriesDetailLoading());
    expect(const TvSeriesDetailHasData(testTvSeriesDetail).props, [
      testTvSeriesDetail,
    ]);
    expect(const TvSeriesDetailError('a').props, ['a']);
    expect(const SeasonDetailEmpty(), const SeasonDetailEmpty());
    expect(const SeasonDetailLoading(), const SeasonDetailLoading());
    expect(const SeasonDetailHasData(testSeasonDetail).props, [
      testSeasonDetail,
    ]);
    expect(const SeasonDetailError('a').props, ['a']);
  });

  test('watchlist status state should support copyWith', () {
    const state = WatchlistTvSeriesStatusState();

    expect(state.copyWith(isAddedToWatchlist: true).isAddedToWatchlist, isTrue);
    expect(state.copyWith(message: 'a').message, 'a');
    expect(state.copyWith().props, [false, '']);
  });
}
