import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailBloc bloc;

  const id = 1;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    bloc = MovieDetailBloc(mockGetMovieDetail);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state, const MovieDetailEmpty());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, HasData] when the detail is fetched successfully',
    build: () {
      when(
        mockGetMovieDetail.execute(id),
      ).thenAnswer((_) async => const Right(testMovieDetail));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchMovieDetail(id)),
    expect: () => [
      const MovieDetailLoading(),
      const MovieDetailHasData(testMovieDetail),
    ],
    verify: (_) => verify(mockGetMovieDetail.execute(id)),
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, Error] when fetching the detail fails',
    build: () {
      when(
        mockGetMovieDetail.execute(id),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchMovieDetail(id)),
    expect: () => [
      const MovieDetailLoading(),
      const MovieDetailError('Server Failure'),
    ],
  );
}
