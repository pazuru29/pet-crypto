import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/cryptocurrency_list.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_empty_view.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_error_view.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_loading_view.dart';
import 'package:pet_crypto/widgets/app_text.dart';

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
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state.alertMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AppText(
                  text: state.alertMessage!.text,
                  textStyle: .bodySemibold,
                  textColor: Colors.black,
                ),
                backgroundColor: state.alertMessage!.type.getColor(context),
              ),
            );
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case .initial:
            case .loading:
              return const DashboardLoadingView();
            case .error:
              return DashboardErrorView(
                message: state.errorMessage,
                onTryAgain: () {
                  _dashboardBloc.add(DashboardInitEvent());
                },
              );
            case .loaded:
              if (state.listOfCrypto.isEmpty) {
                return DashboardEmptyView();
              }

              return CryptocurrencyList(
                listOfCrypto: state.listOfCrypto,
                onRefresh: () async {
                  _dashboardBloc.add(DashboardRefreshDataEvent());
                },
              );
          }
        },
      ),
    );
  }
}
