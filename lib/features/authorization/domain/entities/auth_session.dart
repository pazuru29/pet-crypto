class AuthSession {
  final String accessToken;
  final String refreshToken;
  final String fullName;
  final String email;
  final String image;

  AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.fullName,
    required this.email,
    required this.image,
  });
}
