import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_now_playing_movies.dart';
import 'movie_list_state.dart';

sealed class NowPlayingMoviesEvent extends Equatable {
  const NowPlayingMoviesEvent();

  @override
  List<Object?> get props => [];
}

/// Meminta daftar film yang sedang tayang.
final class FetchNowPlayingMovies extends NowPlayingMoviesEvent {
  const FetchNowPlayingMovies();
}

class NowPlayingMoviesBloc extends Bloc<NowPlayingMoviesEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc(this.getNowPlayingMovies)
    : super(const MovieListEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(const MovieListLoading());

      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    });
  }
}
