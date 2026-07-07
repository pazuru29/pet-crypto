import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/cryptocurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_user_image.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({required this.getCryptocurrency, required this.getUserImage})
    : super(DashboardState.initial()) {
    on<DashboardInitEvent>(_dashboardInitEvent);
    on<DashboardRefreshDataEvent>(_dashboardRefreshDataEvent);
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

    final response = await getCryptocurrency.call();

    switch (response) {
      case Ok(value: final listOfCrypto):
        emit(state.copyWith(status: .loaded, listOfCrypto: listOfCrypto));
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
