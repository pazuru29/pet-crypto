part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final BlocStatus status;
  final AppErrorCode? errorCode;
  final BlocMessage? alertMessage;
  final UserData? profileData;

  const ProfileState({
    required this.status,
    this.errorCode,
    this.alertMessage,
    this.profileData,
  });

  const ProfileState.initial() : this(status: .initial);

  ProfileState copyWith({
    BlocStatus? status,
    AppErrorCode? errorCode,
    BlocMessage? alertToShow,
    UserData? profileData,
  }) => ProfileState(
    status: status ?? this.status,
    errorCode: errorCode,
    alertMessage: alertToShow,
    profileData: profileData ?? this.profileData,
  );

  @override
  List<Object?> get props => [status, errorCode, alertMessage, profileData];
}
