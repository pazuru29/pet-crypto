import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';

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
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          switch (state.status) {
            case .initial:
            case .loading:
              return Center(child: CircularProgressIndicator());
            case .error:
              return Container(color: Colors.red);
            default:
              return SafeArea(
                child: ListView.builder(
                  itemCount: state.listOfCrypto.length,
                  itemBuilder: (context, index) {
                    Cryptocurrency item = state.listOfCrypto[index];

                    return Card(
                      child: Padding(
                        padding: .symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              '${item.name} (${item.symbol})',
                              style: TextStyle(fontWeight: .bold, fontSize: 18),
                            ),
                            Text(
                              'Price: ${item.price?['USD']}\$',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
