import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockSearchMovies mockSearchMovies;
  late MovieSearchBloc bloc;

  const query = 'spiderman';

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(mockSearchMovies);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state, const MovieListEmpty());
  });

  blocTest<MovieSearchBloc, MovieListState>(
    'should emit [Loading, HasData] when the search succeeds',
    build: () {
      when(
        mockSearchMovies.execute(query),
      ).thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnMovieQueryChanged(query)),
    wait: MovieSearchBloc.debounceDuration + const Duration(milliseconds: 300),
    expect: () => [const MovieListLoading(), MovieListHasData(testMovieList)],
    verify: (_) => verify(mockSearchMovies.execute(query)),
  );

  blocTest<MovieSearchBloc, MovieListState>(
    'should emit [Loading, Error] when the search fails',
    build: () {
      when(
        mockSearchMovies.execute(query),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnMovieQueryChanged(query)),
    wait: MovieSearchBloc.debounceDuration + const Duration(milliseconds: 300),
    expect: () => [
      const MovieListLoading(),
      const MovieListError('Server Failure'),
    ],
  );

  blocTest<MovieSearchBloc, MovieListState>(
    'should emit empty and skip the use case when the query is blank',
    build: () => bloc,
    act: (bloc) => bloc.add(const OnMovieQueryChanged('')),
    wait: MovieSearchBloc.debounceDuration + const Duration(milliseconds: 300),
    expect: () => [const MovieListEmpty()],
    verify: (_) => verifyNever(mockSearchMovies.execute('')),
  );

  blocTest<MovieSearchBloc, MovieListState>(
    'should only process the last query while typing',
    build: () {
      when(
        mockSearchMovies.execute(query),
      ).thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc
      ..add(const OnMovieQueryChanged('spid'))
      ..add(const OnMovieQueryChanged(query)),
    wait: MovieSearchBloc.debounceDuration + const Duration(milliseconds: 300),
    expect: () => [const MovieListLoading(), MovieListHasData(testMovieList)],
    verify: (_) {
      verify(mockSearchMovies.execute(query));
      verifyNever(mockSearchMovies.execute('spid'));
    },
  );
}
