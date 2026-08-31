import 'package:equatable/equatable.dart';

import 'episode.dart';

class SeasonDetail extends Equatable {
  final String? airDate;
  final List<Episode> episodes;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  const SeasonDetail({
    required this.airDate,
    required this.episodes,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  @override
  List<Object?> get props => [
    airDate,
    episodes,
    id,
    name,
    overview,
    posterPath,
    seasonNumber,
  ];
}
