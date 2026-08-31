import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../entities/tv_series.dart';
import '../repositories/tv_series_repository.dart';

class GetTopRatedTvSeries {
  final TvSeriesRepository repository;

  GetTopRatedTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getTopRatedTvSeries();
  }
}
