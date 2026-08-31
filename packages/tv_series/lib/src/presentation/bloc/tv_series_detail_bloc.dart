import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tv_series_detail.dart';
import '../../domain/usecases/get_tv_series_detail.dart';

sealed class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();
}

/// Meminta detail serial TV berdasarkan [id].
final class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;

  const FetchTvSeriesDetail(this.id);

  @override
  List<Object?> get props => [id];
}

sealed class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState();

  @override
  List<Object?> get props => [];
}

final class TvSeriesDetailEmpty extends TvSeriesDetailState {
  const TvSeriesDetailEmpty();
}

final class TvSeriesDetailLoading extends TvSeriesDetailState {
  const TvSeriesDetailLoading();
}

final class TvSeriesDetailHasData extends TvSeriesDetailState {
  final TvSeriesDetail result;

  const TvSeriesDetailHasData(this.result);

  @override
  List<Object?> get props => [result];
}

final class TvSeriesDetailError extends TvSeriesDetailState {
  final String message;

  const TvSeriesDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;

  TvSeriesDetailBloc(this.getTvSeriesDetail)
    : super(const TvSeriesDetailEmpty()) {
    on<FetchTvSeriesDetail>((event, emit) async {
      emit(const TvSeriesDetailLoading());

      final result = await getTvSeriesDetail.execute(event.id);
      result.fold(
        (failure) => emit(TvSeriesDetailError(failure.message)),
        (tvSeries) => emit(TvSeriesDetailHasData(tvSeries)),
      );
    });
  }
}
