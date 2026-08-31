import 'package:core/core.dart';
import 'package:movie/movie.dart';

// ---------------------------------------------------------------------------
// Movie
// ---------------------------------------------------------------------------

const testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school '
      'student Peter Parker is endowed with amazing powers to become the '
      'Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

const testMovieModel = MovieModel(
  adult: false,
  backdropPath: '/path.jpg',
  genreIds: [1, 2, 3, 4],
  id: 1,
  originalTitle: 'Original Title',
  overview: 'Overview',
  popularity: 1.0,
  posterPath: '/path.jpg',
  releaseDate: '2020-05-05',
  title: 'Title',
  video: false,
  voteAverage: 1.0,
  voteCount: 1,
);

final testMovieModelList = [testMovieModel];

const testMovieFromModel = Movie(
  adult: false,
  backdropPath: '/path.jpg',
  genreIds: [1, 2, 3, 4],
  id: 1,
  originalTitle: 'Original Title',
  overview: 'Overview',
  popularity: 1.0,
  posterPath: '/path.jpg',
  releaseDate: '2020-05-05',
  title: 'Title',
  video: false,
  voteAverage: 1.0,
  voteCount: 1,
);

final testMovieFromModelList = [testMovieFromModel];

const testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

const testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};
