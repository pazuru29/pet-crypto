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

  bool _showScrollTopButton = false;

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
    if (!_controller.hasClients) return;

    final position = _controller.position;
    final paginationThreshold = position.viewportDimension * 0.6;
    final showButtonOffset = position.viewportDimension * 0.8;

    if (position.extentAfter < paginationThreshold &&
        !widget.paginationLoading) {
      widget.onScroll();
    }

    final shouldShowButton = position.pixels > showButtonOffset;

    if (shouldShowButton != _showScrollTopButton) {
      setState(() {
        _showScrollTopButton = shouldShowButton;
      });
    }
  }

  void _scrollToTop() {
    if (!_controller.hasClients) return;

    _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: widget.onRefresh,
          backgroundColor: colorScheme.primaryContainer,
          color: colorScheme.onPrimaryContainer,
          child: ListView.builder(
            controller: _controller,
            itemCount: widget.listOfCrypto.length + 1,
            itemBuilder: (context, index) {
              if (index == widget.listOfCrypto.length) {
                if (widget.paginationLoading) {
                  return AppPaginationLoading();
                } else {
                  return SizedBox(height: 28);
                }
              }

              final item = widget.listOfCrypto[index];

              return Card(
                color: colorScheme.primaryContainer,
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
                        textColor: colorScheme.onPrimaryContainer,
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
                          textColor: colorScheme.onPrimaryContainer,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          right: 16,
          bottom: 36,
          child: AnimatedScale(
            scale: _showScrollTopButton ? 1 : 0,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            child: FloatingActionButton.small(
              onPressed: _showScrollTopButton ? _scrollToTop : null,
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              child: const Icon(Icons.keyboard_arrow_up),
            ),
          ),
        ),
      ],
    );
  }
}
