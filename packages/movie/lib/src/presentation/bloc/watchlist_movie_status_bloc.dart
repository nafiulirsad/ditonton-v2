import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_detail.dart';
import '../../domain/usecases/get_watchlist_status.dart';
import '../../domain/usecases/remove_watchlist.dart';
import '../../domain/usecases/save_watchlist.dart';

sealed class WatchlistMovieStatusEvent extends Equatable {
  const WatchlistMovieStatusEvent();
}

/// Memeriksa apakah film dengan [id] sudah ada pada watchlist.
final class LoadWatchlistMovieStatus extends WatchlistMovieStatusEvent {
  final int id;

  const LoadWatchlistMovieStatus(this.id);

  @override
  List<Object?> get props => [id];
}

/// Menyimpan film ke watchlist.
final class AddMovieToWatchlist extends WatchlistMovieStatusEvent {
  final MovieDetail movie;

  const AddMovieToWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

/// Menghapus film dari watchlist.
final class RemoveMovieFromWatchlist extends WatchlistMovieStatusEvent {
  final MovieDetail movie;

  const RemoveMovieFromWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

/// Status watchlist sebuah film beserta pesan hasil operasi terakhir.
class WatchlistMovieStatusState extends Equatable {
  final bool isAddedToWatchlist;
  final String message;

  const WatchlistMovieStatusState({
    this.isAddedToWatchlist = false,
    this.message = '',
  });

  WatchlistMovieStatusState copyWith({
    bool? isAddedToWatchlist,
    String? message,
  }) {
    return WatchlistMovieStatusState(
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [isAddedToWatchlist, message];
}

class WatchlistMovieStatusBloc
    extends Bloc<WatchlistMovieStatusEvent, WatchlistMovieStatusState> {
  static const String watchlistAddSuccessMessage = 'Added to Watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistMovieStatusBloc({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const WatchlistMovieStatusState()) {
    on<LoadWatchlistMovieStatus>((event, emit) async {
      final status = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });

    on<AddMovieToWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);
      await _emitResult(
        result.fold((f) => f.message, (m) => m),
        event.movie.id,
        emit,
      );
    });

    on<RemoveMovieFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);
      await _emitResult(
        result.fold((f) => f.message, (m) => m),
        event.movie.id,
        emit,
      );
    });
  }

  Future<void> _emitResult(
    String message,
    int id,
    Emitter<WatchlistMovieStatusState> emit,
  ) async {
    final status = await getWatchListStatus.execute(id);
    emit(
      WatchlistMovieStatusState(isAddedToWatchlist: status, message: message),
    );
  }
}
