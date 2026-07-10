import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';
import 'package:pet_crypto/widgets/error_view.dart';
import 'package:pet_crypto/widgets/loading_view.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  late AuthBloc _authCubit;

  @override
  void initState() {
    _authCubit = context.read<AuthBloc>();
    _authCubit.add(AuthCheckEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => switch (state.status) {
        .error => ErrorView(
          message: state.errorMessage,
          onTryAgain: () {
            _authCubit.add(AuthCheckEvent());
          },
        ),
        .initial ||
        .loading ||
        .loaded => Scaffold(body: SafeArea(child: LoadingView())),
      },
    );
  }
}
