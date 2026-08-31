import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_series.dart';

/// State bersama untuk seluruh bloc yang menghasilkan daftar serial TV.
sealed class TvSeriesListState extends Equatable {
  const TvSeriesListState();

  @override
  List<Object?> get props => [];
}

/// Belum ada permintaan data yang dijalankan.
final class TvSeriesListEmpty extends TvSeriesListState {
  const TvSeriesListEmpty();
}

/// Data sedang diambil.
final class TvSeriesListLoading extends TvSeriesListState {
  const TvSeriesListLoading();
}

/// Data berhasil diambil.
final class TvSeriesListHasData extends TvSeriesListState {
  final List<TvSeries> result;

  const TvSeriesListHasData(this.result);

  @override
  List<Object?> get props => [result];
}

/// Pengambilan data gagal.
final class TvSeriesListError extends TvSeriesListState {
  final String message;

  const TvSeriesListError(this.message);

  @override
  List<Object?> get props => [message];
}
