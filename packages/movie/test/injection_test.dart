import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:movie/movie.dart';

void main() {
  late GetIt locator;

  setUp(() {
    locator = GetIt.asNewInstance();
    locator.registerLazySingleton<http.Client>(
      () => MockClient((request) async => http.Response('{}', 200)),
    );
    locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

    registerMovieDependencies(locator);
  });

  tearDown(() => locator.reset());

  test('should register the data layer of the movie module', () {
    expect(locator<MovieRemoteDataSource>(), isA<MovieRemoteDataSourceImpl>());
    expect(locator<MovieLocalDataSource>(), isA<MovieLocalDataSourceImpl>());
    expect(locator<MovieRepository>(), isA<MovieRepositoryImpl>());
  });

  test('should register every movie use case', () {
    expect(locator<GetNowPlayingMovies>(), isA<GetNowPlayingMovies>());
    expect(locator<GetPopularMovies>(), isA<GetPopularMovies>());
    expect(locator<GetTopRatedMovies>(), isA<GetTopRatedMovies>());
    expect(locator<GetMovieDetail>(), isA<GetMovieDetail>());
    expect(locator<GetMovieRecommendations>(), isA<GetMovieRecommendations>());
    expect(locator<SearchMovies>(), isA<SearchMovies>());
    expect(locator<GetWatchlistMovies>(), isA<GetWatchlistMovies>());
    expect(locator<GetWatchListStatus>(), isA<GetWatchListStatus>());
    expect(locator<SaveWatchlist>(), isA<SaveWatchlist>());
    expect(locator<RemoveWatchlist>(), isA<RemoveWatchlist>());
  });

  test('should register every movie bloc', () {
    expect(locator<NowPlayingMoviesBloc>(), isA<NowPlayingMoviesBloc>());
    expect(locator<PopularMoviesBloc>(), isA<PopularMoviesBloc>());
    expect(locator<TopRatedMoviesBloc>(), isA<TopRatedMoviesBloc>());
    expect(locator<MovieSearchBloc>(), isA<MovieSearchBloc>());
    expect(locator<MovieDetailBloc>(), isA<MovieDetailBloc>());
    expect(
      locator<MovieRecommendationsBloc>(),
      isA<MovieRecommendationsBloc>(),
    );
    expect(locator<WatchlistMoviesBloc>(), isA<WatchlistMoviesBloc>());
    expect(
      locator<WatchlistMovieStatusBloc>(),
      isA<WatchlistMovieStatusBloc>(),
    );
  });
}
