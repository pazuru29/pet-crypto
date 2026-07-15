import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/core/ui/alert_helper.dart';
import 'package:pet_crypto/core/util/app_icons.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/core/util/login_validator.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';
import 'package:pet_crypto/widgets/app_button.dart';
import 'package:pet_crypto/widgets/app_icon_button.dart';
import 'package:pet_crypto/widgets/app_text.dart';
import 'package:pet_crypto/widgets/app_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthBloc _authCubit;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;
  bool _showPassword = false;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _authCubit = context.read<AuthBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    final userField = AppTextFormField(
      controller: _usernameController,
      textInputAction: TextInputAction.next,
      validator: (text) => LoginValidator.validateUsername(context, text),
      autofillHints: const [AutofillHints.username],
      labelText: S.of(context).loginUsername,
      prefixIcon: Icon(Icons.person, size: 20, color: colorScheme.secondary),
    );

    final passwordField = AppTextFormField(
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _login(),
      validator: (text) => LoginValidator.validatePassword(context, text),
      keyboardType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      obscureText: !_showPassword,
      labelText: S.of(context).loginPassword,
      prefixIcon: Icon(Icons.lock, size: 20, color: colorScheme.secondary),
      suffixIcon: AppIconButton.svgIcon(
        svgIcon: _showPassword ? AppIcons.icEye : AppIcons.icEyeSlash,
        borderRadius: .only(
          topRight: .circular(10),
          bottomRight: .circular(10),
        ),
        iconColor: colorScheme.secondary,
        padding: .all(14),
        onPressed: () {
          setState(() {
            _showPassword = !_showPassword;
          });
        },
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.authStatus == AuthStatus.authorized) {
                TextInput.finishAutofillContext(shouldSave: true);
              }

              if (state.alertMessage != null) {
                AlertHelper.showBanner(context, state.alertMessage!);
              }
            },
            builder: (context, state) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: .symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      mainAxisAlignment: .center,
                      spacing: 20,
                      children: [
                        Spacer(),
                        AppText(
                          text: S.of(context).loginTitle,
                          textStyle: AppTextStyle.titleBold,
                          textColor: colorScheme.primary,
                        ),
                        AutofillGroup(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              spacing: 16,
                              children: [userField, passwordField],
                            ),
                          ),
                        ),
                        AppButton(
                          text: S.of(context).loginButton,
                          prefixIcon: state.status == .loading
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                )
                              : null,
                          onPressed:
                              state.status == .loading ||
                                  state.authStatus == .authorized
                              ? null
                              : _login,
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
      ),
    );
  }

  void _login() {
    if (_authCubit.state.status == .loading ||
        _authCubit.state.authStatus == .authorized) {
      return;
    }

    if (_formKey.currentState?.validate() != true) return;

    _authCubit.add(
      AuthLoginEvent(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }
}
