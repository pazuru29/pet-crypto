part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final BlocStatus status;

  const ProfileState({required this.status});

  const ProfileState.initial() : this(status: .initial);

  ProfileState copyWith({BlocStatus? status}) =>
      ProfileState(status: status ?? this.status);

  @override
  List<Object?> get props => [status];
}
