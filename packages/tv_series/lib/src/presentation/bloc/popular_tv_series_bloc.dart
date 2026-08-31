import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_popular_tv_series.dart';
import 'tv_series_list_state.dart';

sealed class PopularTvSeriesEvent extends Equatable {
  const PopularTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

/// Meminta daftar serial TV populer.
final class FetchPopularTvSeries extends PopularTvSeriesEvent {
  const FetchPopularTvSeries();
}

class PopularTvSeriesBloc
    extends Bloc<PopularTvSeriesEvent, TvSeriesListState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc(this.getPopularTvSeries)
    : super(const TvSeriesListEmpty()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(const TvSeriesListLoading());

      final result = await getPopularTvSeries.execute();
      result.fold(
        (failure) => emit(TvSeriesListError(failure.message)),
        (tvSeries) => emit(TvSeriesListHasData(tvSeries)),
      );
    });
  }
}
