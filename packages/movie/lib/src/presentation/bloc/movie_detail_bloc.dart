import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_detail.dart';
import '../../domain/usecases/get_movie_detail.dart';

sealed class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
}

/// Meminta detail film berdasarkan [id].
final class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object?> get props => [id];
}

sealed class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

final class MovieDetailEmpty extends MovieDetailState {
  const MovieDetailEmpty();
}

final class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

final class MovieDetailHasData extends MovieDetailState {
  final MovieDetail result;

  const MovieDetailHasData(this.result);

  @override
  List<Object?> get props => [result];
}

final class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc(this.getMovieDetail) : super(const MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(const MovieDetailLoading());

      final result = await getMovieDetail.execute(event.id);
      result.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (movie) => emit(MovieDetailHasData(movie)),
      );
    });
  }
}
