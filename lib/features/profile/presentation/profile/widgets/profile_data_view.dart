import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_header_widget.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_locale_widget.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_theme_widget.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';
import 'package:pet_crypto/widgets/app_button.dart';

class ProfileDataView extends StatelessWidget {
  final String? initUserImage;
  final UserData? profileData;
  final void Function(int) onChangeTheme;
  final void Function(String?) onChangeLanguage;

  const ProfileDataView({
    super.key,
    this.initUserImage,
    this.profileData,
    required this.onChangeTheme,
    required this.onChangeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ProfileHeaderWidget(
            initUserImage: initUserImage,
            profileImage: profileData?.image,
            fullName: profileData?.fullName,
            needPlaceHolder: profileData?.image == null,
          ),
        ),
        SliverToBoxAdapter(
          child: ProfileThemeWidget(onButtonPressed: onChangeTheme),
        ),
        SliverToBoxAdapter(
          child: ProfileLocaleWidget(onLanguageChoose: onChangeLanguage),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: .all(16),
            child: BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.authStatus != current.authStatus,
              builder: (context, state) {
                final isLoggingOut =
                    state.status == .loading && state.authStatus == .authorized;

                return AppButton(
                  text: S.of(context).profileLogout,
                  suffixIcon: Icon(Icons.exit_to_app),
                  prefixIcon: isLoggingOut
                      ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 1),
                        )
                      : null,
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.errorContainer,
                  onPressed: isLoggingOut
                      ? null
                      : () {
                          context.read<AuthBloc>().add(AuthLogoutEvent());
                        },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
