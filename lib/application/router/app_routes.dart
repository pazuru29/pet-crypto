enum AppRoutes {
  authGate('/', 'authGate'),
  login('/login', 'login'),
  dashboard('/dashboard', 'dashboard'),
  dashboardCryptoDetails('/crypto-details/:id', 'crypto_details'),
  profile('/profile', 'profile');

  final String path;
  final String routeName;

  const AppRoutes(this.path, this.routeName);
}
