import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecommendationsBloc bloc;

  const id = 1;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    bloc = MovieRecommendationsBloc(mockGetMovieRecommendations);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state, const MovieListEmpty());
  });

  blocTest<MovieRecommendationsBloc, MovieListState>(
    'should emit [Loading, HasData] when recommendations are fetched',
    build: () {
      when(
        mockGetMovieRecommendations.execute(id),
      ).thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchMovieRecommendations(id)),
    expect: () => [const MovieListLoading(), MovieListHasData(testMovieList)],
    verify: (_) => verify(mockGetMovieRecommendations.execute(id)),
  );

  blocTest<MovieRecommendationsBloc, MovieListState>(
    'should emit [Loading, Error] when fetching recommendations fails',
    build: () {
      when(
        mockGetMovieRecommendations.execute(id),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchMovieRecommendations(id)),
    expect: () => [
      const MovieListLoading(),
      const MovieListError('Server Failure'),
    ],
  );
}
