import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String? fullName;
  final String? email;
  final String? image;

  const UserData({
    required this.fullName,
    required this.email,
    required this.image,
  });

  @override
  List<Object?> get props => [fullName, email, image];
}
