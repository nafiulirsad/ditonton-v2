import 'package:bloc_test/bloc_test.dart';
import 'package:movie/movie.dart';

/// Mock bloc untuk pengujian widget modul movie.
///
/// `MockBloc` menyediakan stream state yang dapat dikendalikan lewat
/// `whenListen` sehingga halaman dapat diuji tanpa menjalankan use case asli.
class MockNowPlayingMoviesBloc
    extends MockBloc<NowPlayingMoviesEvent, MovieListState>
    implements NowPlayingMoviesBloc {}

class MockPopularMoviesBloc extends MockBloc<PopularMoviesEvent, MovieListState>
    implements PopularMoviesBloc {}

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, MovieListState>
    implements TopRatedMoviesBloc {}

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieListState>
    implements MovieSearchBloc {}

class MockWatchlistMoviesBloc
    extends MockBloc<WatchlistMoviesEvent, MovieListState>
    implements WatchlistMoviesBloc {}

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockMovieRecommendationsBloc
    extends MockBloc<MovieRecommendationsEvent, MovieListState>
    implements MovieRecommendationsBloc {}

class MockWatchlistMovieStatusBloc
    extends MockBloc<WatchlistMovieStatusEvent, WatchlistMovieStatusState>
    implements WatchlistMovieStatusBloc {}
