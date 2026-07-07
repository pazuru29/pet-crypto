import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_cubit.dart';
import 'package:pet_crypto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_header_widget.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_loading_view.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_locale_widget.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_theme_widget.dart';
import 'package:pet_crypto/widgets/app_button.dart';
import 'package:pet_crypto/widgets/app_title.dart';
import 'package:pet_crypto/widgets/error_view.dart';

class ProfileScreen extends StatefulWidget {
  final String? initUserImage;

  const ProfileScreen({super.key, this.initUserImage});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    _profileBloc = context.read<ProfileBloc>();
    _profileBloc.add(ProfileInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            AppTitle(title: S.of(context).profileTitle),
            Flexible(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state.status == .error) {
                    return ErrorView(
                      message: state.errorMessage,
                      onTryAgain: () {
                        _profileBloc.add(ProfileInitEvent());
                      },
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: ProfileHeaderWidget(
                          initUserImage: widget.initUserImage,
                          profileImage: state.profileData?.userImage,
                          fullName: state.profileData?.fullName,
                          needPlaceHolder:
                              state.profileData?.userImage == null &&
                              state.status == .loaded,
                        ),
                      ),
                      if (state.status == .initial || state.status == .loading)
                        ProfileLoadingView(),
                      if (state.status == .loaded) ...[
                        SliverToBoxAdapter(
                          child: ProfileThemeWidget(
                            onButtonPressed: (index) {
                              _profileBloc.add(
                                ProfileChangeThemeModeEvent(themeIndex: index),
                              );
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: ProfileLocaleWidget(
                            onLanguageChoose: (languageCode) {
                              _profileBloc.add(
                                ProfileChangeLocaleEvent(
                                  languageCode: languageCode,
                                ),
                              );
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: .all(16),
                            child: AppButton(
                              text: S.of(context).profileLogout,
                              suffixIcon: Icon(Icons.exit_to_app),
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.errorContainer,
                              onPressed: () {
                                context.read<AuthCubit>().logout();
                              },
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
