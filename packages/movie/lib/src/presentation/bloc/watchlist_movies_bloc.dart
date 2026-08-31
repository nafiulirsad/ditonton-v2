import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_watchlist_movies.dart';
import 'movie_list_state.dart';

sealed class WatchlistMoviesEvent extends Equatable {
  const WatchlistMoviesEvent();

  @override
  List<Object?> get props => [];
}

/// Meminta daftar film yang tersimpan pada watchlist.
final class FetchWatchlistMovies extends WatchlistMoviesEvent {
  const FetchWatchlistMovies();
}

class WatchlistMoviesBloc extends Bloc<WatchlistMoviesEvent, MovieListState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc(this.getWatchlistMovies) : super(const MovieListEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(const MovieListLoading());

      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    });
  }
}
