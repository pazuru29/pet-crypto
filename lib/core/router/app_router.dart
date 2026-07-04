import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_crypto/core/router/app_routes.dart';
import 'package:pet_crypto/di/dependency_injector.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/get_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/dashboard_screen.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.dashboard.path,
    routes: [
      GoRoute(
        path: AppRoutes.dashboard.path,
        name: AppRoutes.dashboard.routeName,
        builder: (context, state) => BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(DI.get<GetCryptocurrency>()),
          child: DashboardScreen(),
        ),
      ),
    ],
  );
}
