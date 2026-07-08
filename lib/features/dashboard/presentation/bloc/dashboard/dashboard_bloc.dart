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
    on<DashboardInitEvent>(_dashboardInitEvent);
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

  FutureOr<void> _dashboardInitEvent(
    DashboardInitEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: .loading));

    final userImageResponse = getUserImage.call();

    switch (userImageResponse) {
      case Ok(value: final image):
        emit(state.copyWith(userImage: image));
      case Err(failure: final error):
        emit(
          state.copyWith(alertMessageToShow: BlocMessage.error(error.message)),
        );
    }

    emit(state.copyWith(currentPaginationStart: 1, currentPaginationLimit: 20));

    final request = DashboardCryptocurrencyRequest(
      start: state.currentPaginationStart,
      limit: state.currentPaginationLimit,
    );

    final response = await getCryptocurrency.call(request: request);

    switch (response) {
      case Ok(value: final listOfCrypto):
        emit(
          state.copyWith(
            status: .loaded,
            listOfCrypto: listOfCrypto,
            hasNextPage: _checkForHasNextPage(listOfCrypto.length),
          ),
        );
      case Err(failure: final failure):
        emit(state.copyWith(status: .error, errorMessage: failure.message));
    }
  }

  FutureOr<void> _dashboardRefreshDataEvent(
    DashboardRefreshDataEvent event,
    Emitter<DashboardState> emit,
  ) async {
    add(DashboardInitEvent());
  }

  bool _checkForHasNextPage(int length) {
    return length > 0 && length == state.currentPaginationLimit;
  }

  FutureOr<void> _dashboardNextPageEvent(
    DashboardNextPageEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (!state.hasNextPage || state.paginationLoading) {
      return;
    }

    emit(state.copyWith(paginationLoading: true));

    int paginationStart =
        state.currentPaginationStart + state.currentPaginationLimit;

    final request = DashboardCryptocurrencyRequest(
      start: paginationStart,
      limit: state.currentPaginationLimit,
    );

    final response = await getCryptocurrency.call(request: request);

    switch (response) {
      case Ok(value: final listOfCrypto):
        final list = [...state.listOfCrypto, ...listOfCrypto];
        emit(
          state.copyWith(
            listOfCrypto: list,
            hasNextPage: _checkForHasNextPage(listOfCrypto.length),
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
}
