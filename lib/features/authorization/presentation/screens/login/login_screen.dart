import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/core/util/app_icons.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';
import 'package:pet_crypto/widgets/app_button.dart';
import 'package:pet_crypto/widgets/app_icon_button.dart';
import 'package:pet_crypto/widgets/app_text.dart';
import 'package:pet_crypto/widgets/app_text_form_filed.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthBloc _authCubit;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _authCubit = context.read<AuthBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: .symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    mainAxisAlignment: .center,
                    spacing: 16,
                    children: [
                      Spacer(),
                      AppText(
                        text: 'LogIn',
                        textStyle: AppTextStyle.titleBold,
                        textColor: colorScheme.primary,
                      ),
                      AppTextFormFiled(
                        controller: _usernameController,
                        autofillHints: const [
                          AutofillHints.username,
                          AutofillHints.email,
                        ],
                        labelText: 'Username',
                        prefixIcon: Icon(
                          Icons.person,
                          size: 20,
                          color: colorScheme.secondary,
                        ),
                      ),
                      AppTextFormFiled(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        autofillHints: const [AutofillHints.password],
                        obscureText: !false,
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          size: 20,
                          color: colorScheme.secondary,
                        ),
                        suffixIcon: AppIconButton.svgIcon(
                          svgIcon: false ? AppIcons.icEye : AppIcons.icEyeSlash,
                          borderRadius: .only(
                            topRight: .circular(10),
                            bottomRight: .circular(10),
                          ),
                          iconColor: colorScheme.secondary,
                          padding: .all(14),
                          onPressed: () {},
                        ),
                      ),
                      AppButton(
                        text: S.of(context).authorizationLogin,
                        onPressed: () {
                          _authCubit.add(
                            AuthLoginEvent(
                              username: _usernameController.text,
                              password: _passwordController.text,
                            ),
                          );
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
