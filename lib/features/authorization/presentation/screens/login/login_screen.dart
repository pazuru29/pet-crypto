import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';
import 'package:pet_crypto/widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthBloc _authCubit;

  @override
  void initState() {
    _authCubit = context.read<AuthBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AppButton(
            text: S.of(context).authorizationLogin,
            onPressed: () {
              //TODO
              _authCubit.add(
                AuthLoginEvent(username: 'emilys', password: 'emilyspass'),
              );
            },
          ),
        ),
      ),
    );
  }
}
