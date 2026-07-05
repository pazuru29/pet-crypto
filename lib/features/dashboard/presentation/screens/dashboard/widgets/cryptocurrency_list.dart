import 'package:flutter/material.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/cryptocurrency.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class CryptocurrencyList extends StatelessWidget {
  final List<Cryptocurrency> listOfCrypto;
  final Future<void> Function() onRefresh;

  const CryptocurrencyList({
    super.key,
    required this.listOfCrypto,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: onRefresh,
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
                  spacing: 8,
                  children: [
                    AppText(
                      text: '${item.name} (${item.symbol})',
                      textStyle: .headerBold,
                    ),
                    for (final price in item.prices)
                      AppText(
                        text: _formatPrice(price),
                        textStyle: .bodyRegular,
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
    return '${price.currencyCode}: ${price.amount}';
  }
}
