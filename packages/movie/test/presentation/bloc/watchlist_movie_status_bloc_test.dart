import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late WatchlistMovieStatusBloc bloc;

  const id = 1;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = WatchlistMovieStatusBloc(
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  tearDown(() => bloc.close());

  test('initial state should not be on the watchlist', () {
    expect(bloc.state, const WatchlistMovieStatusState());
  });

  blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
    'should emit the watchlist status of a movie',
    build: () {
      when(mockGetWatchListStatus.execute(id)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadWatchlistMovieStatus(id)),
    expect: () => [const WatchlistMovieStatusState(isAddedToWatchlist: true)],
    verify: (_) => verify(mockGetWatchListStatus.execute(id)),
  );

  blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
    'should emit a success message after saving a movie',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
        (_) async =>
            const Right(WatchlistMovieStatusBloc.watchlistAddSuccessMessage),
      );
      when(mockGetWatchListStatus.execute(id)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(const AddMovieToWatchlist(testMovieDetail)),
    expect: () => [
      const WatchlistMovieStatusState(
        isAddedToWatchlist: true,
        message: WatchlistMovieStatusBloc.watchlistAddSuccessMessage,
      ),
    ],
    verify: (_) => verify(mockSaveWatchlist.execute(testMovieDetail)),
  );

  blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
    'should emit a success message after removing a movie',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
        (_) async =>
            const Right(WatchlistMovieStatusBloc.watchlistRemoveSuccessMessage),
      );
      when(mockGetWatchListStatus.execute(id)).thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(const RemoveMovieFromWatchlist(testMovieDetail)),
    expect: () => [
      const WatchlistMovieStatusState(
        message: WatchlistMovieStatusBloc.watchlistRemoveSuccessMessage,
      ),
    ],
    verify: (_) => verify(mockRemoveWatchlist.execute(testMovieDetail)),
  );

  blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
    'should emit a failure message when saving fails',
    build: () {
      when(
        mockSaveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(id)).thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(const AddMovieToWatchlist(testMovieDetail)),
    expect: () => [const WatchlistMovieStatusState(message: 'Failed')],
  );

  blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
    'should emit a failure message when removing fails',
    build: () {
      when(
        mockRemoveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(id)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(const RemoveMovieFromWatchlist(testMovieDetail)),
    expect: () => [
      const WatchlistMovieStatusState(
        isAddedToWatchlist: true,
        message: 'Failed',
      ),
    ],
  );
}
