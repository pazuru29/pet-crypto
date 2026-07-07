import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/application/app_settings_controller.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';
import 'package:pet_crypto/features/profile/domain/entities/profile_data.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_get_data.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.profileGetData,
    required this.appSettingsController,
  }) : super(ProfileState.initial()) {
    on<ProfileInitEvent>(_profileInitEvent);
    on<ProfileChangeThemeModeEvent>(_profileChangeThemeModeEvent);
    on<ProfileChangeLocaleEvent>(_profileChangeLocaleEvent);
  }

  final AppSettingsController appSettingsController;
  final ProfileGetData profileGetData;

  FutureOr<void> _profileInitEvent(
    ProfileInitEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    final response = await profileGetData.call();
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
    await appSettingsController.setThemeMode(event.themeIndex);
  }

  FutureOr<void> _profileChangeLocaleEvent(
    ProfileChangeLocaleEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.languageCode == null) return;
    await appSettingsController.setLocale(event.languageCode!);
  }
}
