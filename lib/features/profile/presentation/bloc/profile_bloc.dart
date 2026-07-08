import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/core/result/result.dart';
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
    on<ProfileInitEvent>(_profileInitEvent);
    on<ProfileChangeThemeModeEvent>(_profileChangeThemeModeEvent);
    on<ProfileChangeLocaleEvent>(_profileChangeLocaleEvent);
  }

  final ProfileChangeLocale profileChangeLocale;
  final ProfileChangeThemeMode profileChangeThemeMode;
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
    await profileChangeThemeMode.setThemeMode(event.themeIndex);
  }

  FutureOr<void> _profileChangeLocaleEvent(
    ProfileChangeLocaleEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.languageCode == null) return;
    await profileChangeLocale.setLocale(event.languageCode!);
  }
}
