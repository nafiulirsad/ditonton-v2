import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final String? airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final int? runtime;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;

  const Episode({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.runtime,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });

  @override
  List<Object?> get props => [
    airDate,
    episodeNumber,
    id,
    name,
    overview,
    runtime,
    seasonNumber,
    stillPath,
    voteAverage,
    voteCount,
  ];
}
