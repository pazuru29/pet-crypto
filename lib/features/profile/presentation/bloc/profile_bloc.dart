import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/core/util/bloc/bloc_status.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileInitEvent>(_profileInitEvent);
  }

  FutureOr<void> _profileInitEvent(
    ProfileInitEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    //TODO
    emit(state.copyWith(status: .loaded));
  }
}
