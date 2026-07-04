import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
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
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          final message = state.alertMessage;
          if (message == null) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message.text),
              backgroundColor: _messageBackgroundColor(context, message.type),
            ),
          );
        },
        builder: (context, state) {
          switch (state.status) {
            case .initial:
            case .loading:
              return const Center(child: CircularProgressIndicator());
            case .error:
              return _ErrorView(
                message: state.errorMessage ?? 'Something went wrong',
                onRetry: _refreshData,
              );
            case .loaded:
              if (state.listOfCrypto.isEmpty) {
                return _EmptyView(onRefresh: _refreshData);
              }

              return _CryptocurrencyList(listOfCrypto: state.listOfCrypto);
          }
        },
      ),
    );
  }

  void _refreshData() {
    _dashboardBloc.add(DashboardRefreshDataEvent());
  }

  Color? _messageBackgroundColor(
    BuildContext context,
    BlocMessageType messageType,
  ) {
    switch (messageType) {
      case .error:
        return Theme.of(context).colorScheme.error;
      case .info:
        return null;
    }
  }
}

class _CryptocurrencyList extends StatelessWidget {
  final List<Cryptocurrency> listOfCrypto;

  const _CryptocurrencyList({required this.listOfCrypto});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(DashboardRefreshDataEvent());
        },
        child: ListView.builder(
          itemCount: listOfCrypto.length,
          itemBuilder: (context, index) {
            final item = listOfCrypto[index];

            return Card(
              child: Padding(
                padding: .symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      '${item.name} (${item.symbol})',
                      style: const TextStyle(fontWeight: .bold, fontSize: 18),
                    ),
                    for (final price in item.prices)
                      Text(
                        'Price: ${_formatPrice(price)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatPrice(CryptocurrencyPrice price) {
    return '${price.amount} ${price.currencyCode}';
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: .min,
            children: [
              Icon(Icons.error_outline, color: colorScheme.error, size: 40),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: .center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: .min,
            children: [
              Icon(
                Icons.search_off,
                color: Theme.of(context).colorScheme.outline,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                'No cryptocurrencies found',
                textAlign: .center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
