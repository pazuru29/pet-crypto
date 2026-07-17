import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/core/errors/app_error_code.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/crypto_details_get_info.dart';
import 'package:url_launcher/url_launcher.dart';

part 'crypto_details_event.dart';

part 'crypto_details_state.dart';

class CryptoDetailsBloc extends Bloc<CryptoDetailsEvent, CryptoDetailsState> {
  CryptoDetailsBloc({required this.getInfo})
    : super(CryptoDetailsState.initial()) {
    on<CryptoDetailsInitEvent>(
      _cryptoDetailsInitEvent,
      transformer: restartable(),
    );
    on<CryptoDetailsOpenLinkEvent>(
      _cryptoDetailsOpenLinkEvent,
      transformer: droppable(),
    );
  }

  final CryptoDetailsGetInfo getInfo;

  FutureOr<void> _cryptoDetailsInitEvent(
    CryptoDetailsInitEvent event,
    Emitter<CryptoDetailsState> emit,
  ) async {
    emit(state.copyWith(status: .loading));

    final response = await getInfo.call(idString: event.id);

    switch (response) {
      case Ok(value: final info):
        emit(state.copyWith(status: .loaded, info: info));
      case Err(failure: final error):
        emit(state.copyWith(status: .error, errorCode: error.code));
    }
  }

  FutureOr<void> _cryptoDetailsOpenLinkEvent(
    CryptoDetailsOpenLinkEvent event,
    Emitter<CryptoDetailsState> emit,
  ) async {
    if (state.status != .loaded) {
      return;
    }

    final uri = Uri.tryParse(event.link);

    if (uri == null || !uri.hasScheme) {
      emit(state.copyWith(alertToShow: BlocMessage.error(.invalidLink)));
      return;
    }

    final isAllowedScheme = (uri.scheme == 'https' || uri.scheme == 'http');

    if (!isAllowedScheme) {
      emit(state.copyWith(alertToShow: BlocMessage.error(.unsupportedLink)));
      return;
    }

    if (uri.host.isEmpty) {
      emit(state.copyWith(alertToShow: BlocMessage.error(.invalidLink)));
      return;
    }

    bool opened;

    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      emit(state.copyWith(alertToShow: BlocMessage.error(.openLinkFailed)));
      return;
    }

    if (!opened) {
      emit(state.copyWith(alertToShow: BlocMessage.error(.openLinkFailed)));
    }
  }
}
