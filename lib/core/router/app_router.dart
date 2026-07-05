import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_crypto/core/router/app_routes.dart';
import 'package:pet_crypto/core/router/go_router_refresh_stream.dart';
import 'package:pet_crypto/di/dependency_injector.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_cubit.dart';
import 'package:pet_crypto/features/authorization/presentation/screens/login/login_screen.dart';
import 'package:pet_crypto/features/authorization/presentation/screens/splash/splash_screen.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/dashboard_screen.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash.path,
    refreshListenable: GoRouterRefreshStream(DI.get<AuthCubit>().stream),
    routes: [
      GoRoute(
        path: AppRoutes.splash.path,
        name: AppRoutes.splash.routeName,
        builder: (context, state) => SplashScreen(),
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
        builder: (context, state) => BlocProvider<DashboardBloc>(
          create: (context) => DI.get<DashboardBloc>(),
          child: DashboardScreen(),
        ),
      ),
    ],
    redirect: (context, state) {
      final authState = DI.get<AuthCubit>().state;
      final location = state.matchedLocation;

      final isSplash = location == AppRoutes.splash.path;
      final isLogin = location == AppRoutes.login.path;
      final isDashboard = location == AppRoutes.dashboard.path;

      if (authState.authStatus == AuthStatus.unknown) {
        return isSplash ? null : AppRoutes.splash.path;
      }

      if (authState.authStatus == AuthStatus.unauthorized) {
        return isLogin ? null : AppRoutes.login.path;
      }

      if (authState.authStatus == AuthStatus.authorized && isLogin) {
        return isDashboard ? null : AppRoutes.dashboard.path;
      }

      return null;
    },
  );
}
