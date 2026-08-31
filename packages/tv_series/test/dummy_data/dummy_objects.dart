import 'package:core/core.dart';
import 'package:tv_series/tv_series.dart';

// ---------------------------------------------------------------------------
// TV Series
// ---------------------------------------------------------------------------

const testTvSeries = TvSeries(
  backdropPath: '/path.jpg',
  firstAirDate: '2020-05-05',
  genreIds: [1, 2, 3, 4],
  id: 1,
  name: 'Name',
  originalName: 'Original Name',
  overview: 'Overview',
  popularity: 1.0,
  posterPath: '/path.jpg',
  voteAverage: 1.0,
  voteCount: 1,
);

final testTvSeriesList = [testTvSeries];

const testTvSeriesModel = TvSeriesModel(
  backdropPath: '/path.jpg',
  firstAirDate: '2020-05-05',
  genreIds: [1, 2, 3, 4],
  id: 1,
  name: 'Name',
  originalName: 'Original Name',
  overview: 'Overview',
  popularity: 1.0,
  posterPath: '/path.jpg',
  voteAverage: 1.0,
  voteCount: 1,
);

final testTvSeriesModelList = [testTvSeriesModel];

const testSeasonModel = SeasonModel(
  airDate: '2020-05-05',
  episodeCount: 10,
  id: 1,
  name: 'Season 1',
  overview: 'Overview',
  posterPath: '/path.jpg',
  seasonNumber: 1,
);

const testSeason = Season(
  airDate: '2020-05-05',
  episodeCount: 10,
  id: 1,
  name: 'Season 1',
  overview: 'Overview',
  posterPath: '/path.jpg',
  seasonNumber: 1,
);

const testTvSeriesDetailResponse = TvSeriesDetailResponse(
  backdropPath: '/path.jpg',
  episodeRunTime: [60],
  firstAirDate: '2020-05-05',
  genres: [GenreModel(id: 1, name: 'Action')],
  id: 1,
  name: 'Name',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  originalName: 'Original Name',
  overview: 'Overview',
  popularity: 1.0,
  posterPath: '/path.jpg',
  seasons: [testSeasonModel],
  status: 'Returning Series',
  tagline: 'Tagline',
  voteAverage: 1.0,
  voteCount: 1,
);

const testTvSeriesDetail = TvSeriesDetail(
  backdropPath: '/path.jpg',
  episodeRunTime: [60],
  firstAirDate: '2020-05-05',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  name: 'Name',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  originalName: 'Original Name',
  overview: 'Overview',
  posterPath: '/path.jpg',
  seasons: [testSeason],
  status: 'Returning Series',
  voteAverage: 1.0,
  voteCount: 1,
);

const testEpisodeModel = EpisodeModel(
  airDate: '2020-05-05',
  episodeNumber: 1,
  id: 1,
  name: 'Episode 1',
  overview: 'Overview',
  runtime: 45,
  seasonNumber: 1,
  stillPath: '/path.jpg',
  voteAverage: 1.0,
  voteCount: 1,
);

const testEpisode = Episode(
  airDate: '2020-05-05',
  episodeNumber: 1,
  id: 1,
  name: 'Episode 1',
  overview: 'Overview',
  runtime: 45,
  seasonNumber: 1,
  stillPath: '/path.jpg',
  voteAverage: 1.0,
  voteCount: 1,
);

const testSeasonDetailResponse = SeasonDetailResponse(
  airDate: '2020-05-05',
  episodes: [testEpisodeModel],
  id: 1,
  name: 'Season 1',
  overview: 'Overview',
  posterPath: '/path.jpg',
  seasonNumber: 1,
);

const testSeasonDetail = SeasonDetail(
  airDate: '2020-05-05',
  episodes: [testEpisode],
  id: 1,
  name: 'Season 1',
  overview: 'Overview',
  posterPath: '/path.jpg',
  seasonNumber: 1,
);

const testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'Name',
  posterPath: '/path.jpg',
  overview: 'Overview',
);

const testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'Name',
  posterPath: '/path.jpg',
  overview: 'Overview',
);

final testTvSeriesMap = {
  'id': 1,
  'name': 'Name',
  'overview': 'Overview',
  'posterPath': '/path.jpg',
};
