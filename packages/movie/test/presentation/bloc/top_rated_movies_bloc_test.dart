import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTopRatedMovies mockUseCase;
  late TopRatedMoviesBloc bloc;

  setUp(() {
    mockUseCase = MockGetTopRatedMovies();
    bloc = TopRatedMoviesBloc(mockUseCase);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state, const MovieListEmpty());
  });

  blocTest<TopRatedMoviesBloc, MovieListState>(
    'should emit [Loading, HasData] when the data is fetched successfully',
    build: () {
      when(mockUseCase.execute()).thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedMovies()),
    expect: () => [const MovieListLoading(), MovieListHasData(testMovieList)],
    verify: (_) => verify(mockUseCase.execute()),
  );

  blocTest<TopRatedMoviesBloc, MovieListState>(
    'should emit [Loading, Error] when fetching the data fails',
    build: () {
      when(
        mockUseCase.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedMovies()),
    expect: () => [
      const MovieListLoading(),
      const MovieListError('Server Failure'),
    ],
    verify: (_) => verify(mockUseCase.execute()),
  );
}
