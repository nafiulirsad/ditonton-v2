import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTvSeriesWatchListStatus mockGetWatchListStatus;
  late MockSaveTvSeriesWatchlist mockSaveWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveWatchlist;
  late WatchlistTvSeriesStatusBloc bloc;

  const id = 1;

  setUp(() {
    mockGetWatchListStatus = MockGetTvSeriesWatchListStatus();
    mockSaveWatchlist = MockSaveTvSeriesWatchlist();
    mockRemoveWatchlist = MockRemoveTvSeriesWatchlist();
    bloc = WatchlistTvSeriesStatusBloc(
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  tearDown(() => bloc.close());

  test('initial state should not be on the watchlist', () {
    expect(bloc.state, const WatchlistTvSeriesStatusState());
  });

  blocTest<WatchlistTvSeriesStatusBloc, WatchlistTvSeriesStatusState>(
    'should emit the watchlist status of a tv series',
    build: () {
      when(mockGetWatchListStatus.execute(id)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadWatchlistTvSeriesStatus(id)),
    expect: () => [
      const WatchlistTvSeriesStatusState(isAddedToWatchlist: true),
    ],
    verify: (_) => verify(mockGetWatchListStatus.execute(id)),
  );

  blocTest<WatchlistTvSeriesStatusBloc, WatchlistTvSeriesStatusState>(
    'should emit a success message after saving a tv series',
    build: () {
      when(mockSaveWatchlist.execute(testTvSeriesDetail)).thenAnswer(
        (_) async =>
            const Right(WatchlistTvSeriesStatusBloc.watchlistAddSuccessMessage),
      );
      when(mockGetWatchListStatus.execute(id)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(const AddTvSeriesToWatchlist(testTvSeriesDetail)),
    expect: () => [
      const WatchlistTvSeriesStatusState(
        isAddedToWatchlist: true,
        message: WatchlistTvSeriesStatusBloc.watchlistAddSuccessMessage,
      ),
    ],
    verify: (_) => verify(mockSaveWatchlist.execute(testTvSeriesDetail)),
  );

  blocTest<WatchlistTvSeriesStatusBloc, WatchlistTvSeriesStatusState>(
    'should emit a success message after removing a tv series',
    build: () {
      when(mockRemoveWatchlist.execute(testTvSeriesDetail)).thenAnswer(
        (_) async => const Right(
          WatchlistTvSeriesStatusBloc.watchlistRemoveSuccessMessage,
        ),
      );
      when(mockGetWatchListStatus.execute(id)).thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) =>
        bloc.add(const RemoveTvSeriesFromWatchlist(testTvSeriesDetail)),
    expect: () => [
      const WatchlistTvSeriesStatusState(
        message: WatchlistTvSeriesStatusBloc.watchlistRemoveSuccessMessage,
      ),
    ],
    verify: (_) => verify(mockRemoveWatchlist.execute(testTvSeriesDetail)),
  );

  blocTest<WatchlistTvSeriesStatusBloc, WatchlistTvSeriesStatusState>(
    'should emit a failure message when saving fails',
    build: () {
      when(
        mockSaveWatchlist.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(id)).thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(const AddTvSeriesToWatchlist(testTvSeriesDetail)),
    expect: () => [const WatchlistTvSeriesStatusState(message: 'Failed')],
  );

  blocTest<WatchlistTvSeriesStatusBloc, WatchlistTvSeriesStatusState>(
    'should emit a failure message when removing fails',
    build: () {
      when(
        mockRemoveWatchlist.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(id)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) =>
        bloc.add(const RemoveTvSeriesFromWatchlist(testTvSeriesDetail)),
    expect: () => [
      const WatchlistTvSeriesStatusState(
        isAddedToWatchlist: true,
        message: 'Failed',
      ),
    ],
  );
}
