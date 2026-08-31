import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_series_detail.dart';
import 'season_model.dart';

class TvSeriesDetailResponse extends Equatable {
  final String? backdropPath;
  final List<int> episodeRunTime;
  final String? firstAirDate;
  final List<GenreModel> genres;
  final int id;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<SeasonModel> seasons;
  final String status;
  final String tagline;
  final double voteAverage;
  final int voteCount;

  const TvSeriesDetailResponse({
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
    required this.popularity,
    required this.posterPath,
    required this.seasons,
    required this.status,
    required this.tagline,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailResponse(
        backdropPath: json['backdrop_path'],
        episodeRunTime: List<int>.from(json['episode_run_time'].map((x) => x)),
        firstAirDate: json['first_air_date'],
        genres: List<GenreModel>.from(
          json['genres'].map((x) => GenreModel.fromJson(x)),
        ),
        id: json['id'],
        name: json['name'],
        numberOfEpisodes: json['number_of_episodes'],
        numberOfSeasons: json['number_of_seasons'],
        originalName: json['original_name'],
        overview: json['overview'],
        popularity: json['popularity'].toDouble(),
        posterPath: json['poster_path'],
        seasons: List<SeasonModel>.from(
          json['seasons'].map((x) => SeasonModel.fromJson(x)),
        ),
        status: json['status'],
        tagline: json['tagline'],
        voteAverage: json['vote_average'].toDouble(),
        voteCount: json['vote_count'],
      );

  Map<String, dynamic> toJson() => {
    'backdrop_path': backdropPath,
    'episode_run_time': List<dynamic>.from(episodeRunTime.map((x) => x)),
    'first_air_date': firstAirDate,
    'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
    'id': id,
    'name': name,
    'number_of_episodes': numberOfEpisodes,
    'number_of_seasons': numberOfSeasons,
    'original_name': originalName,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'seasons': List<dynamic>.from(seasons.map((x) => x.toJson())),
    'status': status,
    'tagline': tagline,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };

  TvSeriesDetail toEntity() => TvSeriesDetail(
    backdropPath: backdropPath,
    episodeRunTime: episodeRunTime,
    firstAirDate: firstAirDate,
    genres: genres.map((genre) => genre.toEntity()).toList(),
    id: id,
    name: name,
    numberOfEpisodes: numberOfEpisodes,
    numberOfSeasons: numberOfSeasons,
    originalName: originalName,
    overview: overview,
    posterPath: posterPath,
    seasons: seasons.map((season) => season.toEntity()).toList(),
    status: status,
    voteAverage: voteAverage,
    voteCount: voteCount,
  );

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
    popularity,
    posterPath,
    seasons,
    status,
    tagline,
    voteAverage,
    voteCount,
  ];
}
