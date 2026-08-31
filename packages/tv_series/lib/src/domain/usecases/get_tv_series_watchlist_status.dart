import '../repositories/tv_series_repository.dart';

class GetTvSeriesWatchListStatus {
  final TvSeriesRepository repository;

  GetTvSeriesWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
