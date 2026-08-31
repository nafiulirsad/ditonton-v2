import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

/// State bersama untuk seluruh bloc yang menghasilkan daftar film.
///
/// Dipakai ulang oleh bloc now playing, popular, top rated, pencarian, dan
/// watchlist supaya bentuk state tetap konsisten antar halaman.
sealed class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object?> get props => [];
}

/// Belum ada permintaan data yang dijalankan.
final class MovieListEmpty extends MovieListState {
  const MovieListEmpty();
}

/// Data sedang diambil.
final class MovieListLoading extends MovieListState {
  const MovieListLoading();
}

/// Data berhasil diambil.
final class MovieListHasData extends MovieListState {
  final List<Movie> result;

  const MovieListHasData(this.result);

  @override
  List<Object?> get props => [result];
}

/// Pengambilan data gagal.
final class MovieListError extends MovieListState {
  final String message;

  const MovieListError(this.message);

  @override
  List<Object?> get props => [message];
}
