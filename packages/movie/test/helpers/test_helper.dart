import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:movie/movie.dart';

/// Mock untuk seluruh dependensi modul movie yang dipakai pada pengujian.
@GenerateMocks(
  [
    // repository
    MovieRepository,
    // data source
    MovieRemoteDataSource,
    MovieLocalDataSource,
    DatabaseHelper,
    // use case
    GetNowPlayingMovies,
    GetPopularMovies,
    GetTopRatedMovies,
    GetMovieDetail,
    GetMovieRecommendations,
    SearchMovies,
    GetWatchlistMovies,
    GetWatchListStatus,
    SaveWatchlist,
    RemoveWatchlist,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
