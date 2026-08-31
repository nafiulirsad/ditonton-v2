import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../entities/season_detail.dart';
import '../repositories/tv_series_repository.dart';

class GetSeasonDetail {
  final TvSeriesRepository repository;

  GetSeasonDetail(this.repository);

  Future<Either<Failure, SeasonDetail>> execute(int id, int seasonNumber) {
    return repository.getSeasonDetail(id, seasonNumber);
  }
}
