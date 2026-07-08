import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/core/ui/bloc_message_colors.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_cryptocurrency_list.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_empty_view.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_loading_view.dart';
import 'package:pet_crypto/widgets/app_text.dart';
import 'package:pet_crypto/widgets/app_title_profile.dart';
import 'package:pet_crypto/widgets/error_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardBloc _dashboardBloc;

  @override
  void initState() {
    _dashboardBloc = context.read<DashboardBloc>();
    _dashboardBloc.add(DashboardInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state.alertMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: AppText(
                    text: state.alertMessage!.text,
                    textStyle: .bodySemibold,
                    textColor: state.alertMessage!.type.foregroundColor(
                      context,
                    ),
                  ),
                  backgroundColor: state.alertMessage!.type.backgroundColor(
                    context,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: .start,
              children: [
                AppTitleProfile(
                  title: S.of(context).dashboardTitle,
                  imageUrl: state.userImage,
                  placeHolder:
                      state.status == .loaded && state.userImage == null,
                ),
                if (state.status == .initial || state.status == .loading)
                  Flexible(child: const DashboardLoadingView()),
                if (state.status == .error)
                  Flexible(
                    child: ErrorView(
                      message: state.errorMessage,
                      onTryAgain: () {
                        _dashboardBloc.add(DashboardInitEvent());
                      },
                    ),
                  ),
                if (state.status == .loaded && state.listOfCrypto.isEmpty)
                  Flexible(child: DashboardEmptyView()),
                if (state.status == .loaded && state.listOfCrypto.isNotEmpty)
                  Flexible(
                    child: DashboardCryptocurrencyList(
                      listOfCrypto: state.listOfCrypto,
                      paginationLoading: state.paginationLoading,
                      onRefresh: () async {
                        _dashboardBloc.add(DashboardRefreshDataEvent());
                      },
                      onScroll: () {
                        _dashboardBloc.add(DashboardNextPageEvent());
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
