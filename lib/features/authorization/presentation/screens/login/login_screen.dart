import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_cubit.dart';
import 'package:pet_crypto/widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthCubit _authCubit;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AppButton(
            text: 'Log In',
            onPressed: () {
              //TODO
              _authCubit.login('emilys', 'emilyspass');
            },
          ),
        ),
      ),
    );
  }
}
