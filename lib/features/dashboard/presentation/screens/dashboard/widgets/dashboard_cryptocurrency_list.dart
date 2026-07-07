import 'package:flutter/material.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';
import 'package:pet_crypto/widgets/app_text.dart';

class DashboardCryptocurrencyList extends StatelessWidget {
  final List<DashboardCryptocurrency> listOfCrypto;
  final Future<void> Function() onRefresh;

  const DashboardCryptocurrencyList({
    super.key,
    required this.listOfCrypto,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
