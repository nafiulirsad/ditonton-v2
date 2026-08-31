/// Nama rute yang dipakai bersama oleh seluruh modul fitur.
///
/// Konstanta ini berada pada modul `core` supaya widget bersama (misalnya
/// [AppDrawer]) dapat bernavigasi tanpa perlu bergantung pada modul fitur.
abstract final class AppRoutes {
  static const String homeMovie = '/home';
  static const String popularMovies = '/popular-movie';
  static const String topRatedMovies = '/top-rated-movie';
  static const String movieDetail = '/detail';
  static const String searchMovies = '/search';

  static const String homeTvSeries = '/home-tv-series';
  static const String onTheAirTvSeries = '/on-the-air-tv-series';
  static const String popularTvSeries = '/popular-tv-series';
  static const String topRatedTvSeries = '/top-rated-tv-series';
  static const String tvSeriesDetail = '/detail-tv-series';
  static const String searchTvSeries = '/search-tv-series';
  static const String seasonDetail = '/season-detail';

  static const String watchlist = '/watchlist';
  static const String about = '/about';
}
