import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/di/dependency_injector.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';

class DashboardScope extends StatelessWidget {
  final Widget child;

  const DashboardScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DI.get<DashboardBloc>(),
      child: child,
    );
  }
}
