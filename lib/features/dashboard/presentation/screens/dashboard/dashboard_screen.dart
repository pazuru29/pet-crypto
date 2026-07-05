import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/core/ui/bloc_message_colors.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_cubit.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/cryptocurrency_list.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_empty_view.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_error_view.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_loading_view.dart';
import 'package:pet_crypto/widgets/app_button.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardBloc _dashboardBloc;
  late AuthCubit _authCubit;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _dashboardBloc = context.read<DashboardBloc>();
    _dashboardBloc.add(DashboardInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton(
                onPressed: () {
                  _authCubit.logout();
                },
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            BlocConsumer<DashboardBloc, DashboardState>(
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
                switch (state.status) {
                  case .initial:
                  case .loading:
                    return Flexible(child: const DashboardLoadingView());
                  case .error:
                    return Flexible(
                      child: DashboardErrorView(
                        message: state.errorMessage,
                        onTryAgain: () {
                          _dashboardBloc.add(DashboardInitEvent());
                        },
                      ),
                    );
                  case .loaded:
                    if (state.listOfCrypto.isEmpty) {
                      return Flexible(child: DashboardEmptyView());
                    }

                    return Flexible(
                      child: CryptocurrencyList(
                        listOfCrypto: state.listOfCrypto,
                        onRefresh: () async {
                          _dashboardBloc.add(DashboardRefreshDataEvent());
                        },
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
