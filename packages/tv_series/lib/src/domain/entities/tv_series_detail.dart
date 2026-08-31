import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

import 'season.dart';

class TvSeriesDetail extends Equatable {
  final String? backdropPath;
  final List<int> episodeRunTime;
  final String? firstAirDate;
  final List<Genre> genres;
  final int id;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String originalName;
  final String overview;
  final String? posterPath;
  final List<Season> seasons;
  final String status;
  final double voteAverage;
  final int voteCount;

  const TvSeriesDetail({
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.seasons,
    required this.status,
    required this.voteAverage,
    required this.voteCount,
  });

  @override
  List<Object?> get props => [
    backdropPath,
    episodeRunTime,
    firstAirDate,
    genres,
    id,
    name,
    numberOfEpisodes,
    numberOfSeasons,
    originalName,
    overview,
    posterPath,
    seasons,
    status,
    voteAverage,
    voteCount,
  ];
}
