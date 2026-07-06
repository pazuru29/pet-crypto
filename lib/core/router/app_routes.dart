enum AppRoutes {
  authGate('/', 'authGate'),
  login('/login', 'login'),
  dashboard('/dashboard', 'dashboard'),
  profile('/profile', 'profile');

  final String path;
  final String routeName;

  const AppRoutes(this.path, this.routeName);
}
