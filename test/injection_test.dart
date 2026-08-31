import 'package:core/core.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

/// Pelapor palsu supaya pengujian tidak membutuhkan Firebase.
class _FakeAnalyticsReporter implements AnalyticsReporter {
  @override
  Future<void> logScreenView(String screenName) async {}

  @override
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {}
}

class _FakeCrashReporter implements CrashReporter {
  @override
  Future<void> recordError(Object error, StackTrace? stackTrace) async {}

  @override
  void forceCrash() {}
}

void main() {
  setUp(() async {
    // Klien palsu dipakai supaya pengujian tidak membaca sertifikat SSL dari
    // asset bundle.
    await di.init(
      httpClient: MockClient((request) async => http.Response('{}', 200)),
      analyticsReporter: _FakeAnalyticsReporter(),
      crashReporter: _FakeCrashReporter(),
    );
  });

  tearDown(() => di.locator.reset());

  test('should register the shared dependencies of the core module', () {
    expect(di.locator<http.Client>(), isA<http.Client>());
    expect(di.locator<DatabaseHelper>(), isA<DatabaseHelper>());
    expect(di.locator<AnalyticsReporter>(), isA<AnalyticsReporter>());
    expect(di.locator<CrashReporter>(), isA<CrashReporter>());
  });

  test('should register every movie dependency', () {
    expect(di.locator<MovieRepository>(), isA<MovieRepositoryImpl>());
    expect(
      di.locator<MovieRemoteDataSource>(),
      isA<MovieRemoteDataSourceImpl>(),
    );
    expect(di.locator<MovieLocalDataSource>(), isA<MovieLocalDataSourceImpl>());

    expect(di.locator<GetNowPlayingMovies>(), isA<GetNowPlayingMovies>());
    expect(di.locator<GetPopularMovies>(), isA<GetPopularMovies>());
    expect(di.locator<GetTopRatedMovies>(), isA<GetTopRatedMovies>());
    expect(di.locator<GetMovieDetail>(), isA<GetMovieDetail>());
    expect(
      di.locator<GetMovieRecommendations>(),
      isA<GetMovieRecommendations>(),
    );
    expect(di.locator<SearchMovies>(), isA<SearchMovies>());
    expect(di.locator<GetWatchlistMovies>(), isA<GetWatchlistMovies>());
    expect(di.locator<GetWatchListStatus>(), isA<GetWatchListStatus>());
    expect(di.locator<SaveWatchlist>(), isA<SaveWatchlist>());
    expect(di.locator<RemoveWatchlist>(), isA<RemoveWatchlist>());

    expect(di.locator<NowPlayingMoviesBloc>(), isA<NowPlayingMoviesBloc>());
    expect(di.locator<PopularMoviesBloc>(), isA<PopularMoviesBloc>());
    expect(di.locator<TopRatedMoviesBloc>(), isA<TopRatedMoviesBloc>());
    expect(di.locator<MovieSearchBloc>(), isA<MovieSearchBloc>());
    expect(di.locator<MovieDetailBloc>(), isA<MovieDetailBloc>());
    expect(
      di.locator<MovieRecommendationsBloc>(),
      isA<MovieRecommendationsBloc>(),
    );
    expect(di.locator<WatchlistMoviesBloc>(), isA<WatchlistMoviesBloc>());
    expect(
      di.locator<WatchlistMovieStatusBloc>(),
      isA<WatchlistMovieStatusBloc>(),
    );
  });

  test('should register every tv series dependency', () {
    expect(di.locator<TvSeriesRepository>(), isA<TvSeriesRepositoryImpl>());
    expect(
      di.locator<TvSeriesRemoteDataSource>(),
      isA<TvSeriesRemoteDataSourceImpl>(),
    );
    expect(
      di.locator<TvSeriesLocalDataSource>(),
      isA<TvSeriesLocalDataSourceImpl>(),
    );

    expect(di.locator<GetOnTheAirTvSeries>(), isA<GetOnTheAirTvSeries>());
    expect(di.locator<GetPopularTvSeries>(), isA<GetPopularTvSeries>());
    expect(di.locator<GetTopRatedTvSeries>(), isA<GetTopRatedTvSeries>());
    expect(di.locator<GetTvSeriesDetail>(), isA<GetTvSeriesDetail>());
    expect(
      di.locator<GetTvSeriesRecommendations>(),
      isA<GetTvSeriesRecommendations>(),
    );
    expect(di.locator<SearchTvSeries>(), isA<SearchTvSeries>());
    expect(di.locator<GetSeasonDetail>(), isA<GetSeasonDetail>());
    expect(di.locator<GetWatchlistTvSeries>(), isA<GetWatchlistTvSeries>());
    expect(
      di.locator<GetTvSeriesWatchListStatus>(),
      isA<GetTvSeriesWatchListStatus>(),
    );
    expect(di.locator<SaveTvSeriesWatchlist>(), isA<SaveTvSeriesWatchlist>());
    expect(
      di.locator<RemoveTvSeriesWatchlist>(),
      isA<RemoveTvSeriesWatchlist>(),
    );

    expect(di.locator<OnTheAirTvSeriesBloc>(), isA<OnTheAirTvSeriesBloc>());
    expect(di.locator<PopularTvSeriesBloc>(), isA<PopularTvSeriesBloc>());
    expect(di.locator<TopRatedTvSeriesBloc>(), isA<TopRatedTvSeriesBloc>());
    expect(di.locator<TvSeriesSearchBloc>(), isA<TvSeriesSearchBloc>());
    expect(di.locator<TvSeriesDetailBloc>(), isA<TvSeriesDetailBloc>());
    expect(
      di.locator<TvSeriesRecommendationsBloc>(),
      isA<TvSeriesRecommendationsBloc>(),
    );
    expect(di.locator<WatchlistTvSeriesBloc>(), isA<WatchlistTvSeriesBloc>());
    expect(
      di.locator<WatchlistTvSeriesStatusBloc>(),
      isA<WatchlistTvSeriesStatusBloc>(),
    );
    expect(di.locator<SeasonDetailBloc>(), isA<SeasonDetailBloc>());
  });
}
