import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  final String? backdropPath;
  final String? firstAirDate;
  final List<int>? genreIds;
  final int id;
  final String? name;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final double? voteAverage;
  final int? voteCount;

  const TvSeries({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  const TvSeries.watchlist({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  }) : backdropPath = null,
       firstAirDate = null,
       genreIds = null,
       originalName = null,
       popularity = null,
       voteAverage = null,
       voteCount = null;

  @override
  List<Object?> get props => [
    backdropPath,
    firstAirDate,
    genreIds,
    id,
    name,
    originalName,
    overview,
    popularity,
    posterPath,
    voteAverage,
    voteCount,
  ];
}
