part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final ProfileData? profileData;

  const ProfileState({
    required this.status,
    this.errorMessage,
    this.profileData,
  });

  const ProfileState.initial() : this(status: .initial);

  ProfileState copyWith({
    BlocStatus? status,
    String? errorMessage,
    ProfileData? profileData,
  }) => ProfileState(
    status: status ?? this.status,
    errorMessage: errorMessage,
    profileData: profileData ?? this.profileData,
  );

  @override
  List<Object?> get props => [status, errorMessage, profileData];
}
