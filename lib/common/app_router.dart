import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

import '../injection.dart';
import '../presentation/pages/about_page.dart';
import '../presentation/pages/watchlist_page.dart';

/// Memetakan nama rute menjadi halaman yang sesuai.
///
/// Aplikasi berperan sebagai perekat antar modul: hanya berkas ini yang
/// mengenal halaman dari modul movie maupun tv_series.
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.homeMovie:
      return MaterialPageRoute(builder: (_) => const HomeMoviePage());
    case AppRoutes.homeTvSeries:
      return MaterialPageRoute(builder: (_) => const HomeTvSeriesPage());
    case AppRoutes.popularMovies:
      return CupertinoPageRoute(builder: (_) => const PopularMoviesPage());
    case AppRoutes.topRatedMovies:
      return CupertinoPageRoute(builder: (_) => const TopRatedMoviesPage());
    case AppRoutes.movieDetail:
      final id = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => MovieDetailPage(id: id),
        settings: settings,
      );
    case AppRoutes.searchMovies:
      return CupertinoPageRoute(builder: (_) => const SearchPage());
    case AppRoutes.onTheAirTvSeries:
      return CupertinoPageRoute(builder: (_) => const OnTheAirTvSeriesPage());
    case AppRoutes.popularTvSeries:
      return CupertinoPageRoute(builder: (_) => const PopularTvSeriesPage());
    case AppRoutes.topRatedTvSeries:
      return CupertinoPageRoute(builder: (_) => const TopRatedTvSeriesPage());
    case AppRoutes.tvSeriesDetail:
      final id = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => TvSeriesDetailPage(id: id),
        settings: settings,
      );
    case AppRoutes.searchTvSeries:
      return CupertinoPageRoute(builder: (_) => const SearchTvSeriesPage());
    case AppRoutes.seasonDetail:
      final args = settings.arguments as SeasonDetailArgs;
      return MaterialPageRoute(
        builder: (_) => SeasonDetailPage(args: args),
        settings: settings,
      );
    case AppRoutes.watchlist:
      return MaterialPageRoute(builder: (_) => const WatchlistPage());
    case AppRoutes.about:
      return MaterialPageRoute(
        builder: (_) => AboutPage(
          crashReporter: locator.isRegistered<CrashReporter>()
              ? locator<CrashReporter>()
              : null,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            key: Key('page_not_found'),
            child: Text('Page not found :('),
          ),
        ),
      );
  }
}
