part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class ProfileInitEvent extends ProfileEvent {}

class ProfileChangeThemeModeEvent extends ProfileEvent {
  final int themeIndex;

  ProfileChangeThemeModeEvent({required this.themeIndex});
}

class ProfileChangeLocaleEvent extends ProfileEvent {
  final String? languageCode;

  ProfileChangeLocaleEvent({required this.languageCode});
}
