import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/tv_series_local_data_source.dart';
import 'data/datasources/tv_series_remote_data_source.dart';
import 'data/repositories/tv_series_repository_impl.dart';
import 'domain/repositories/tv_series_repository.dart';
import 'domain/usecases/get_on_the_air_tv_series.dart';
import 'domain/usecases/get_popular_tv_series.dart';
import 'domain/usecases/get_season_detail.dart';
import 'domain/usecases/get_top_rated_tv_series.dart';
import 'domain/usecases/get_tv_series_detail.dart';
import 'domain/usecases/get_tv_series_recommendations.dart';
import 'domain/usecases/get_tv_series_watchlist_status.dart';
import 'domain/usecases/get_watchlist_tv_series.dart';
import 'domain/usecases/remove_tv_series_watchlist.dart';
import 'domain/usecases/save_tv_series_watchlist.dart';
import 'domain/usecases/search_tv_series.dart';
import 'presentation/bloc/on_the_air_tv_series_bloc.dart';
import 'presentation/bloc/popular_tv_series_bloc.dart';
import 'presentation/bloc/season_detail_bloc.dart';
import 'presentation/bloc/top_rated_tv_series_bloc.dart';
import 'presentation/bloc/tv_series_detail_bloc.dart';
import 'presentation/bloc/tv_series_recommendations_bloc.dart';
import 'presentation/bloc/tv_series_search_bloc.dart';
import 'presentation/bloc/watchlist_tv_series_bloc.dart';
import 'presentation/bloc/watchlist_tv_series_status_bloc.dart';

/// Mendaftarkan seluruh dependensi modul tv_series.
///
/// `http.Client` dan [DatabaseHelper] didaftarkan lebih dahulu oleh modul core
/// sehingga modul ini cukup memakainya lewat [locator].
void registerTvSeriesDependencies(GetIt locator) {
  // bloc
  locator.registerFactory(() => OnTheAirTvSeriesBloc(locator()));
  locator.registerFactory(() => PopularTvSeriesBloc(locator()));
  locator.registerFactory(() => TopRatedTvSeriesBloc(locator()));
  locator.registerFactory(() => TvSeriesSearchBloc(locator()));
  locator.registerFactory(() => TvSeriesDetailBloc(locator()));
  locator.registerFactory(() => TvSeriesRecommendationsBloc(locator()));
  locator.registerFactory(() => WatchlistTvSeriesBloc(locator()));
  locator.registerFactory(() => SeasonDetailBloc(locator()));
  locator.registerFactory(
    () => WatchlistTvSeriesStatusBloc(
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetOnTheAirTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetSeasonDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveTvSeriesWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvSeriesWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data source
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
    () => TvSeriesRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
    () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()),
  );
}
