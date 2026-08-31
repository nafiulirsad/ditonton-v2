import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:tv_series/tv_series.dart';

/// Mock untuk seluruh dependensi modul tv_series yang dipakai pada pengujian.
@GenerateMocks(
  [
    // repository
    TvSeriesRepository,
    // data source
    TvSeriesRemoteDataSource,
    TvSeriesLocalDataSource,
    DatabaseHelper,
    // use case
    GetOnTheAirTvSeries,
    GetPopularTvSeries,
    GetTopRatedTvSeries,
    GetTvSeriesDetail,
    GetTvSeriesRecommendations,
    SearchTvSeries,
    GetSeasonDetail,
    GetWatchlistTvSeries,
    GetTvSeriesWatchListStatus,
    SaveTvSeriesWatchlist,
    RemoveTvSeriesWatchlist,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
