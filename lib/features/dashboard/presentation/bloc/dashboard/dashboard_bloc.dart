import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/cryptocurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/get_cryptocurrency.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this.getCryptocurrency) : super(DashboardState.initial()) {
    on<DashboardInitEvent>(_dashboardInitEvent);
    on<DashboardRefreshDataEvent>(_dashboardRefreshDataEvent);
  }

  final GetCryptocurrency getCryptocurrency;

  FutureOr<void> _dashboardInitEvent(
    DashboardInitEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: .loading));

    final response = await getCryptocurrency.call();

    switch (response) {
      case Ok(value: final listOfCrypto):
        emit(
          state.copyWith(
            status: .loaded,
            listOfCrypto: listOfCrypto,
            alertMessageToShow: .info('Success'),
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
}
