import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/ui/alert_helper.dart';
import 'package:pet_crypto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_data_view.dart';
import 'package:pet_crypto/widgets/app_title.dart';
import 'package:pet_crypto/widgets/error_view.dart';
import 'package:pet_crypto/widgets/loading_view.dart';

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
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            AppTitle(title: S.of(context).profileTitle, secondary: true),
            Flexible(
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state.alertMessage != null) {
                    AlertHelper.showSnackBar(context, state.alertMessage!);
                  }
                },
                builder: (context, state) => switch (state.status) {
                  .error => ErrorView(
                    code: state.errorCode,
                    onTryAgain: () {
                      _profileBloc.add(ProfileInitEvent());
                    },
                  ),
                  .loading || .initial => LoadingView(),
                  .loaded => ProfileDataView(
                    initUserImage: widget.initUserImage,
                    profileData: state.profileData,
                    onChangeTheme: (index) {
                      _profileBloc.add(
                        ProfileChangeThemeModeEvent(themeIndex: index),
                      );
                    },
                    onChangeLanguage: (languageCode) {
                      _profileBloc.add(
                        ProfileChangeLocaleEvent(languageCode: languageCode),
                      );
                    },
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
