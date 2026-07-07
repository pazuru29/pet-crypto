import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/util/app_icons.dart';
import 'package:pet_crypto/core/util/app_text_style.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_cubit.dart';
import 'package:pet_crypto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pet_crypto/widgets/app_button.dart';
import 'package:pet_crypto/widgets/app_icon_button.dart';
import 'package:pet_crypto/widgets/app_row_builder.dart';
import 'package:pet_crypto/widgets/app_text.dart';
import 'package:pet_crypto/widgets/app_title.dart';
import 'package:pet_crypto/widgets/profile_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProfileScreen extends StatefulWidget {
  final String? initUserImage;

  const ProfileScreen({super.key, this.initUserImage});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileBloc _profileBloc;
  List<String> listOfThemeIcons = [
    AppIcons.icSystem,
    AppIcons.icSun,
    AppIcons.icMoon,
  ];

  @override
  void initState() {
    _profileBloc = context.read<ProfileBloc>();
    _profileBloc.add(ProfileInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<S>();
    final themeProvider = context.watch<AppThemeProvider>();
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
                    return Container();
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(color: colorScheme.primary),
                          child: Column(
                            mainAxisAlignment: .center,
                            spacing: 8,
                            children: [
                              Hero(
                                tag: 'profileImage',
                                child: ProfileImage(
                                  height: 80,
                                  width: 80,
                                  backgroundColor: colorScheme.primaryContainer,
                                  needPlaceHolder:
                                      state.profileData?.userImage == null &&
                                      state.status == .loaded,
                                  iconPlaceHolderColor: colorScheme.primary,
                                  imageUrl:
                                      widget.initUserImage ??
                                      state.profileData?.userImage,
                                ),
                              ),
                              AppText(
                                text: state.profileData?.fullName ?? '',
                                textStyle: AppTextStyle.headerBold,
                                textColor: colorScheme.onPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (state.status == .initial || state.status == .loading)
                        SliverToBoxAdapter(
                          child: Column(
                            mainAxisSize: .min,
                            spacing: 8,
                            children: [
                              Shimmer(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: .circular(10),
                                  ),
                                ),
                              ),
                              Shimmer(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: .circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (state.status == .loaded) ...[
                        SliverToBoxAdapter(
                          child: Container(
                            margin: .only(left: 16, right: 16, top: 16),
                            padding: .symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: .circular(10),
                            ),
                            child: Column(
                              mainAxisSize: .min,
                              crossAxisAlignment: .start,
                              spacing: 8,
                              children: [
                                AppText(
                                  text: 'Theme',
                                  textStyle: AppTextStyle.bodyBold,
                                  textColor: colorScheme.onPrimaryContainer,
                                ),
                                AppRowBuilder(
                                  itemCount: ThemeMode.values.length,
                                  builder: (context, index) {
                                    bool isSelected =
                                        themeProvider.mode.index == index;
                                    return AppIconButton.svgIcon(
                                      padding: .all(12),
                                      borderRadius: .zero,
                                      svgIcon: listOfThemeIcons[index],
                                      backgroundColor: isSelected
                                          ? colorScheme.primary
                                          : Colors.transparent,
                                      iconColor: isSelected
                                          ? colorScheme.onPrimary
                                          : colorScheme.onPrimaryContainer,
                                      highlightColor: colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      splashColor: colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      onPressed: () async {
                                        await themeProvider.setMode(index);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            margin: .only(left: 16, right: 16, top: 16),
                            padding: .symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: .circular(10),
                            ),
                            child: Column(
                              mainAxisSize: .min,
                              crossAxisAlignment: .start,
                              spacing: 8,
                              children: [
                                AppText(
                                  text: 'Localization',
                                  textStyle: AppTextStyle.bodyBold,
                                  textColor: colorScheme.onPrimaryContainer,
                                ),
                                DropdownMenu<String>(
                                  initialSelection:
                                      localeProvider.locale.languageCode,
                                  onSelected: (String? lang) async {
                                    if (lang == null) return;
                                    await localeProvider.setLocale(lang);
                                  },
                                  dropdownMenuEntries: S.supportedLocales.keys
                                      .map(
                                        (e) => DropdownMenuEntry(
                                          value: e,
                                          label: e.toUpperCase(),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: .all(16),
                            child: AppButton(
                              text: 'Exit',
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
