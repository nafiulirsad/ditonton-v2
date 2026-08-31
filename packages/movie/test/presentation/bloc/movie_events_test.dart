import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('events without payload should be equal', () {
    expect(const FetchNowPlayingMovies(), const FetchNowPlayingMovies());
    expect(const FetchPopularMovies(), const FetchPopularMovies());
    expect(const FetchTopRatedMovies(), const FetchTopRatedMovies());
    expect(const FetchWatchlistMovies(), const FetchWatchlistMovies());
    expect(const FetchNowPlayingMovies().props, isEmpty);
    expect(const FetchPopularMovies().props, isEmpty);
    expect(const FetchTopRatedMovies().props, isEmpty);
    expect(const FetchWatchlistMovies().props, isEmpty);
  });

  test('base events should expose an empty property list', () {
    const MovieSearchEvent search = OnMovieQueryChanged('a');
    const MovieDetailEvent detail = FetchMovieDetail(1);
    const MovieRecommendationsEvent recommendations = FetchMovieRecommendations(
      1,
    );
    const WatchlistMovieStatusEvent status = LoadWatchlistMovieStatus(1);

    expect(search, isA<MovieSearchEvent>());
    expect(detail, isA<MovieDetailEvent>());
    expect(recommendations, isA<MovieRecommendationsEvent>());
    expect(status, isA<WatchlistMovieStatusEvent>());
  });

  test('events with payload should compare their payload', () {
    expect(const FetchMovieDetail(1), const FetchMovieDetail(1));
    expect(const FetchMovieDetail(1), isNot(const FetchMovieDetail(2)));
    expect(const FetchMovieRecommendations(1).props, [1]);
    expect(const OnMovieQueryChanged('a').props, ['a']);
    expect(const LoadWatchlistMovieStatus(1).props, [1]);
    expect(const AddMovieToWatchlist(testMovieDetail).props, [testMovieDetail]);
    expect(const RemoveMovieFromWatchlist(testMovieDetail).props, [
      testMovieDetail,
    ]);
  });

  test('states should compare their payload', () {
    expect(const MovieListEmpty(), const MovieListEmpty());
    expect(const MovieListLoading(), const MovieListLoading());
    expect(MovieListHasData(testMovieList).props, [testMovieList]);
    expect(const MovieListError('a').props, ['a']);
    expect(const MovieDetailEmpty().props, isEmpty);
    expect(const MovieDetailLoading().props, isEmpty);
    expect(const MovieListEmpty().props, isEmpty);
    expect(const MovieListLoading().props, isEmpty);
    expect(const MovieDetailEmpty(), const MovieDetailEmpty());
    expect(const MovieDetailLoading(), const MovieDetailLoading());
    expect(const MovieDetailHasData(testMovieDetail).props, [testMovieDetail]);
    expect(const MovieDetailError('a').props, ['a']);
  });

  test('watchlist status state should support copyWith', () {
    const state = WatchlistMovieStatusState();

    expect(state.copyWith(isAddedToWatchlist: true).isAddedToWatchlist, isTrue);
    expect(state.copyWith(message: 'a').message, 'a');
    expect(state.copyWith().props, [false, '']);
  });
}
