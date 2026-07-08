import 'package:flutter/material.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';
import 'package:pet_crypto/widgets/app_pagination_loading.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class DashboardCryptocurrencyList extends StatefulWidget {
  final List<DashboardCryptocurrency> listOfCrypto;
  final Future<void> Function() onRefresh;
  final VoidCallback onScroll;
  final bool paginationLoading;

  const DashboardCryptocurrencyList({
    super.key,
    required this.listOfCrypto,
    required this.onRefresh,
    required this.onScroll,
    required this.paginationLoading,
  });

  @override
  State<DashboardCryptocurrencyList> createState() =>
      _DashboardCryptocurrencyListState();
}

class _DashboardCryptocurrencyListState
    extends State<DashboardCryptocurrencyList> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_controller.hasClients &&
        _controller.position.maxScrollExtent == _controller.offset) {
      widget.onScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _controller,
        itemCount: widget.listOfCrypto.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.listOfCrypto.length) {
            if (widget.paginationLoading) {
              return AppPaginationLoading();
            } else {
              return SizedBox.shrink();
            }
          }

          final item = widget.listOfCrypto[index];

          return Card(
            child: Padding(
              padding: .symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                spacing: 8,
                children: [
                  AppText(
                    text: S
                        .of(context)
                        .dashboardCryptoTitle(item.name, item.symbol),
                    textStyle: .headerBold,
                  ),
                  for (final price in item.prices)
                    AppText(
                      text: S
                          .of(context)
                          .dashboardPriceCrypto(
                            price.currencyCode,
                            price.amount,
                          ),
                      textStyle: .bodyRegular,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
