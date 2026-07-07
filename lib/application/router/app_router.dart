import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_crypto/application/router/app_router_dependencies.dart';
import 'package:pet_crypto/application/router/app_routes.dart';
import 'package:pet_crypto/application/router/go_router_refresh_stream.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/presentation/screens/auth_gate/auth_gate_screen.dart';
import 'package:pet_crypto/features/authorization/presentation/screens/login/login_screen.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:pet_crypto/features/profile/presentation/profile/profile_screen.dart';

class AppRouter {
  final AppRouterDependencies dependencies;

  AppRouter({required this.dependencies});

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.authGate.path,
    refreshListenable: GoRouterRefreshStream(dependencies.authCubit.stream),
    routes: [
      GoRoute(
        path: AppRoutes.authGate.path,
        name: AppRoutes.authGate.routeName,
        builder: (context, state) => AuthGateScreen(),
      ),
      GoRoute(
        path: AppRoutes.login.path,
        name: AppRoutes.login.routeName,
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            child: LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(
                      curve: Curves.easeIn,
                    ).animate(animation),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.dashboard.path,
        name: AppRoutes.dashboard.routeName,
        builder: (context, state) => BlocProvider(
          create: (context) => dependencies.createDashboardBloc(),
          child: DashboardScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile.path,
        name: AppRoutes.profile.routeName,
        builder: (context, state) => ProfileScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = dependencies.authCubit.state;
      final location = state.matchedLocation;

      final isAuthGate = location == AppRoutes.authGate.path;
      final isLogin = location == AppRoutes.login.path;
      final isAuthRoute = isAuthGate || isLogin;

      if (authState.authStatus == AuthStatus.unknown) {
        return isAuthGate ? null : AppRoutes.authGate.path;
      }

      if (authState.authStatus == AuthStatus.unauthorized) {
        return isLogin ? null : AppRoutes.login.path;
      }

      if (authState.authStatus == AuthStatus.authorized) {
        return isAuthRoute ? AppRoutes.dashboard.path : null;
      }

      return null;
    },
  );
}
