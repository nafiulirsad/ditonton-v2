import 'package:equatable/equatable.dart';

import '../../domain/entities/season_detail.dart';
import 'episode_model.dart';

class SeasonDetailResponse extends Equatable {
  final String? airDate;
  final List<EpisodeModel> episodes;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  const SeasonDetailResponse({
    required this.airDate,
    required this.episodes,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        airDate: json['air_date'],
        episodes: List<EpisodeModel>.from(
          (json['episodes'] as List).map((x) => EpisodeModel.fromJson(x)),
        ),
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        seasonNumber: json['season_number'],
      );

  Map<String, dynamic> toJson() => {
    'air_date': airDate,
    'episodes': List<dynamic>.from(episodes.map((x) => x.toJson())),
    'id': id,
    'name': name,
    'overview': overview,
    'poster_path': posterPath,
    'season_number': seasonNumber,
  };

  SeasonDetail toEntity() => SeasonDetail(
    airDate: airDate,
    episodes: episodes.map((episode) => episode.toEntity()).toList(),
    id: id,
    name: name,
    overview: overview,
    posterPath: posterPath,
    seasonNumber: seasonNumber,
  );

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
