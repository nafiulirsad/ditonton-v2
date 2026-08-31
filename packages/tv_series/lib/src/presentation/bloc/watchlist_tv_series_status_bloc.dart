import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tv_series_detail.dart';
import '../../domain/usecases/get_tv_series_watchlist_status.dart';
import '../../domain/usecases/remove_tv_series_watchlist.dart';
import '../../domain/usecases/save_tv_series_watchlist.dart';

sealed class WatchlistTvSeriesStatusEvent extends Equatable {
  const WatchlistTvSeriesStatusEvent();
}

/// Memeriksa apakah serial TV dengan [id] sudah ada pada watchlist.
final class LoadWatchlistTvSeriesStatus extends WatchlistTvSeriesStatusEvent {
  final int id;

  const LoadWatchlistTvSeriesStatus(this.id);

  @override
  List<Object?> get props => [id];
}

/// Menyimpan serial TV ke watchlist.
final class AddTvSeriesToWatchlist extends WatchlistTvSeriesStatusEvent {
  final TvSeriesDetail tvSeries;

  const AddTvSeriesToWatchlist(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

/// Menghapus serial TV dari watchlist.
final class RemoveTvSeriesFromWatchlist extends WatchlistTvSeriesStatusEvent {
  final TvSeriesDetail tvSeries;

  const RemoveTvSeriesFromWatchlist(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

/// Status watchlist sebuah serial TV beserta pesan hasil operasi terakhir.
class WatchlistTvSeriesStatusState extends Equatable {
  final bool isAddedToWatchlist;
  final String message;

  const WatchlistTvSeriesStatusState({
    this.isAddedToWatchlist = false,
    this.message = '',
  });

  WatchlistTvSeriesStatusState copyWith({
    bool? isAddedToWatchlist,
    String? message,
  }) {
    return WatchlistTvSeriesStatusState(
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [isAddedToWatchlist, message];
}

class WatchlistTvSeriesStatusBloc
    extends Bloc<WatchlistTvSeriesStatusEvent, WatchlistTvSeriesStatusState> {
  static const String watchlistAddSuccessMessage = 'Added to Watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesWatchListStatus getWatchListStatus;
  final SaveTvSeriesWatchlist saveWatchlist;
  final RemoveTvSeriesWatchlist removeWatchlist;

  WatchlistTvSeriesStatusBloc({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const WatchlistTvSeriesStatusState()) {
    on<LoadWatchlistTvSeriesStatus>((event, emit) async {
      final status = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });

    on<AddTvSeriesToWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.tvSeries);
      await _emitResult(
        result.fold((f) => f.message, (m) => m),
        event.tvSeries.id,
        emit,
      );
    });

    on<RemoveTvSeriesFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.tvSeries);
      await _emitResult(
        result.fold((f) => f.message, (m) => m),
        event.tvSeries.id,
        emit,
      );
    });
  }

  Future<void> _emitResult(
    String message,
    int id,
    Emitter<WatchlistTvSeriesStatusState> emit,
  ) async {
    final status = await getWatchListStatus.execute(id);
    emit(
      WatchlistTvSeriesStatusState(
        isAddedToWatchlist: status,
        message: message,
      ),
    );
  }
}
