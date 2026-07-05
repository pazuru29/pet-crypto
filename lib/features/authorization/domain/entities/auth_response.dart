class AuthResponse {
  final String fullName;
  final String email;
  final String image;
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.fullName,
    required this.email,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
  });
}
