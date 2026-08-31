import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tv_series/tv_series.dart';

void main() {
  late GetIt locator;

  setUp(() {
    locator = GetIt.asNewInstance();
    locator.registerLazySingleton<http.Client>(
      () => MockClient((request) async => http.Response('{}', 200)),
    );
    locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

    registerTvSeriesDependencies(locator);
  });

  tearDown(() => locator.reset());

  test('should register the data layer of the tv series module', () {
    expect(
      locator<TvSeriesRemoteDataSource>(),
      isA<TvSeriesRemoteDataSourceImpl>(),
    );
    expect(
      locator<TvSeriesLocalDataSource>(),
      isA<TvSeriesLocalDataSourceImpl>(),
    );
    expect(locator<TvSeriesRepository>(), isA<TvSeriesRepositoryImpl>());
  });

  test('should register every tv series use case', () {
    expect(locator<GetOnTheAirTvSeries>(), isA<GetOnTheAirTvSeries>());
    expect(locator<GetPopularTvSeries>(), isA<GetPopularTvSeries>());
    expect(locator<GetTopRatedTvSeries>(), isA<GetTopRatedTvSeries>());
    expect(locator<GetTvSeriesDetail>(), isA<GetTvSeriesDetail>());
    expect(
      locator<GetTvSeriesRecommendations>(),
      isA<GetTvSeriesRecommendations>(),
    );
    expect(locator<SearchTvSeries>(), isA<SearchTvSeries>());
    expect(locator<GetSeasonDetail>(), isA<GetSeasonDetail>());
    expect(locator<GetWatchlistTvSeries>(), isA<GetWatchlistTvSeries>());
    expect(
      locator<GetTvSeriesWatchListStatus>(),
      isA<GetTvSeriesWatchListStatus>(),
    );
    expect(locator<SaveTvSeriesWatchlist>(), isA<SaveTvSeriesWatchlist>());
    expect(locator<RemoveTvSeriesWatchlist>(), isA<RemoveTvSeriesWatchlist>());
  });

  test('should register every tv series bloc', () {
    expect(locator<OnTheAirTvSeriesBloc>(), isA<OnTheAirTvSeriesBloc>());
    expect(locator<PopularTvSeriesBloc>(), isA<PopularTvSeriesBloc>());
    expect(locator<TopRatedTvSeriesBloc>(), isA<TopRatedTvSeriesBloc>());
    expect(locator<TvSeriesSearchBloc>(), isA<TvSeriesSearchBloc>());
    expect(locator<TvSeriesDetailBloc>(), isA<TvSeriesDetailBloc>());
    expect(
      locator<TvSeriesRecommendationsBloc>(),
      isA<TvSeriesRecommendationsBloc>(),
    );
    expect(locator<WatchlistTvSeriesBloc>(), isA<WatchlistTvSeriesBloc>());
    expect(
      locator<WatchlistTvSeriesStatusBloc>(),
      isA<WatchlistTvSeriesStatusBloc>(),
    );
    expect(locator<SeasonDetailBloc>(), isA<SeasonDetailBloc>());
  });
}
