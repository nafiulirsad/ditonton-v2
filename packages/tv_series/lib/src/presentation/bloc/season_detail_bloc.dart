import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/season_detail.dart';
import '../../domain/usecases/get_season_detail.dart';

sealed class SeasonDetailEvent extends Equatable {
  const SeasonDetailEvent();
}

/// Meminta daftar episode pada sebuah season.
final class FetchSeasonDetail extends SeasonDetailEvent {
  final int id;
  final int seasonNumber;

  const FetchSeasonDetail({required this.id, required this.seasonNumber});

  @override
  List<Object?> get props => [id, seasonNumber];
}

sealed class SeasonDetailState extends Equatable {
  const SeasonDetailState();

  @override
  List<Object?> get props => [];
}

final class SeasonDetailEmpty extends SeasonDetailState {
  const SeasonDetailEmpty();
}

final class SeasonDetailLoading extends SeasonDetailState {
  const SeasonDetailLoading();
}

final class SeasonDetailHasData extends SeasonDetailState {
  final SeasonDetail result;

  const SeasonDetailHasData(this.result);

  @override
  List<Object?> get props => [result];
}

final class SeasonDetailError extends SeasonDetailState {
  final String message;

  const SeasonDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class SeasonDetailBloc extends Bloc<SeasonDetailEvent, SeasonDetailState> {
  final GetSeasonDetail getSeasonDetail;

  SeasonDetailBloc(this.getSeasonDetail) : super(const SeasonDetailEmpty()) {
    on<FetchSeasonDetail>((event, emit) async {
      emit(const SeasonDetailLoading());

      final result = await getSeasonDetail.execute(
        event.id,
        event.seasonNumber,
      );
      result.fold(
        (failure) => emit(SeasonDetailError(failure.message)),
        (season) => emit(SeasonDetailHasData(season)),
      );
    });
  }
}
