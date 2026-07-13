part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final BlocMessage? alertMessage;
  final UserData? profileData;

  const ProfileState({
    required this.status,
    this.errorMessage,
    this.alertMessage,
    this.profileData,
  });

  const ProfileState.initial() : this(status: .initial);

  ProfileState copyWith({
    BlocStatus? status,
    String? errorMessage,
    BlocMessage? alertToShow,
    UserData? profileData,
  }) => ProfileState(
    status: status ?? this.status,
    errorMessage: errorMessage,
    alertMessage: alertToShow,
    profileData: profileData ?? this.profileData,
  );

  @override
  List<Object?> get props => [status, errorMessage, alertMessage, profileData];
}
