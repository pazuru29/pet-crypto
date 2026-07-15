import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_change_locale.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_change_theme_mode.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_get_data.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.profileGetData,
    required this.profileChangeLocale,
    required this.profileChangeThemeMode,
  }) : super(ProfileState.initial()) {
    on<ProfileInitEvent>(_profileInitEvent, transformer: droppable());
    on<ProfileChangeThemeModeEvent>(
      _profileChangeThemeModeEvent,
      transformer: sequential(),
    );
    on<ProfileChangeLocaleEvent>(
      _profileChangeLocaleEvent,
      transformer: sequential(),
    );
  }

  final ProfileChangeLocale profileChangeLocale;
  final ProfileChangeThemeMode profileChangeThemeMode;
  final ProfileGetData profileGetData;

  FutureOr<void> _profileInitEvent(
    ProfileInitEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    final response = profileGetData.call();
    switch (response) {
      case Ok(value: final profileData):
        emit(state.copyWith(status: .loaded, profileData: profileData));
      case Err(failure: final error):
        emit(state.copyWith(status: .error, errorMessage: error.message));
    }
  }

  FutureOr<void> _profileChangeThemeModeEvent(
    ProfileChangeThemeModeEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await profileChangeThemeMode.call(event.themeIndex);
    if (result case Err()) {
      emit(
        state.copyWith(alertToShow: BlocMessage.error(result.failure.message)),
      );
    }
  }

  FutureOr<void> _profileChangeLocaleEvent(
    ProfileChangeLocaleEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.languageCode == null) return;
    final result = await profileChangeLocale.call(event.languageCode!);
    if (result case Err()) {
      emit(
        state.copyWith(alertToShow: BlocMessage.error(result.failure.message)),
      );
    }
  }
}
