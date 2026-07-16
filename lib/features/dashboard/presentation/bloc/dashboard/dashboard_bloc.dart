import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency_request.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_user_image.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({required this.getCryptocurrency, required this.getUserImage})
    : super(DashboardState.initial()) {
    on<DashboardInitEvent>(_dashboardInitEvent, transformer: droppable());
    on<DashboardRefreshDataEvent>(
      _dashboardRefreshDataEvent,
      transformer: droppable(),
    );
    on<DashboardNextPageEvent>(
      _dashboardNextPageEvent,
      transformer: droppable(),
    );
  }

  // UseCases
  final DashboardGetCryptocurrency getCryptocurrency;
  final DashboardGetUserImage getUserImage;

  int _dataRevision = 0;
  bool _refreshInProgress = false;

  FutureOr<void> _dashboardInitEvent(
    DashboardInitEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final revision = ++_dataRevision;

    emit(state.copyWith(status: .loading, paginationLoading: false));

    final userImageResponse = getUserImage.call();

    switch (userImageResponse) {
      case Ok(value: final image):
        emit(state.copyWith(userImage: image));
      case Err(failure: final error):
        emit(
          state.copyWith(alertMessageToShow: BlocMessage.error(error.message)),
        );
    }

    const int start = 1;
    const int limit = 20;

    final response = await _getCryptocurrency(start: start, limit: limit);

    if (revision != _dataRevision) return;

    switch (response) {
      case Ok(value: final listOfCrypto):
        emit(
          state.copyWith(
            status: .loaded,
            currentPaginationStart: start,
            currentPaginationLimit: limit,
            listOfCrypto: listOfCrypto,
            hasNextPage: _checkForHasNextPage(listOfCrypto.length, limit),
          ),
        );
      case Err(failure: final failure):
        emit(
          state.copyWith(
            status: .error,
            errorMessage: failure.message,
            currentPaginationLimit: limit,
            currentPaginationStart: start,
          ),
        );
    }
  }

  FutureOr<void> _dashboardRefreshDataEvent(
    DashboardRefreshDataEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.status != .loaded) {
      _completeRefresh(event);
      return;
    }

    final revision = ++_dataRevision;
    _refreshInProgress = true;

    emit(state.copyWith(paginationLoading: false));

    try {
      const int start = 1;
      const int limit = 20;

      final response = await _getCryptocurrency(start: start, limit: limit);

      if (revision != _dataRevision) return;

      switch (response) {
        case Ok(value: final listOfCrypto):
          emit(
            state.copyWith(
              currentPaginationStart: start,
              currentPaginationLimit: limit,
              listOfCrypto: listOfCrypto,
              hasNextPage: _checkForHasNextPage(listOfCrypto.length, limit),
            ),
          );
        case Err(failure: final failure):
          emit(
            state.copyWith(
              alertMessageToShow: BlocMessage.error(failure.message),
            ),
          );
      }
    } finally {
      _refreshInProgress = false;
      _completeRefresh(event);
    }
  }

  FutureOr<void> _dashboardNextPageEvent(
    DashboardNextPageEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.status != .loaded ||
        !state.hasNextPage ||
        state.paginationLoading ||
        _refreshInProgress) {
      return;
    }

    final revision = _dataRevision;
    final paginationLimit = state.currentPaginationLimit;
    final paginationStart = state.currentPaginationStart + paginationLimit;

    emit(state.copyWith(paginationLoading: true));

    final request = DashboardCryptocurrencyRequest(
      start: paginationStart,
      limit: paginationLimit,
    );

    final response = await getCryptocurrency.call(request: request);

    if (revision != _dataRevision) return;

    switch (response) {
      case Ok(value: final listOfCrypto):
        final list = [...state.listOfCrypto, ...listOfCrypto];
        emit(
          state.copyWith(
            listOfCrypto: list,
            hasNextPage: _checkForHasNextPage(
              listOfCrypto.length,
              paginationLimit,
            ),
            currentPaginationStart: paginationStart,
            paginationLoading: false,
          ),
        );
      case Err(failure: final failure):
        emit(
          state.copyWith(
            alertMessageToShow: BlocMessage.error(failure.message),
            paginationLoading: false,
          ),
        );
    }
  }

  bool _checkForHasNextPage(int length, int limit) {
    return length > 0 && length == limit;
  }

  void _completeRefresh(DashboardRefreshDataEvent event) {
    if (!event.completer.isCompleted) {
      event.completer.complete();
    }
  }

  Future<Result<List<DashboardCryptocurrency>>> _getCryptocurrency({
    required int start,
    required int limit,
  }) async {
    final request = DashboardCryptocurrencyRequest(start: start, limit: limit);

    return await getCryptocurrency.call(request: request);
  }
}
