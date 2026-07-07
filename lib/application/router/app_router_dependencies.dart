import 'package:pet_crypto/features/authorization/presentation/bloc/auth_cubit.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';

class AppRouterDependencies {
  final AuthCubit authCubit;
  final DashboardBloc Function() createDashboardBloc;

  const AppRouterDependencies({
    required this.authCubit,
    required this.createDashboardBloc,
  });
}
