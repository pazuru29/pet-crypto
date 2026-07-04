enum AppRoutes {
  dashboard('/', 'dashboard');

  final String path;
  final String routeName;

  const AppRoutes(this.path, this.routeName);
}
