import 'package:bloc_test/bloc_test.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';

/// Mock bloc watchlist yang dipakai pada pengujian halaman gabungan.
class MockWatchlistMoviesBloc
    extends MockBloc<WatchlistMoviesEvent, MovieListState>
    implements WatchlistMoviesBloc {}

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, TvSeriesListState>
    implements WatchlistTvSeriesBloc {}
