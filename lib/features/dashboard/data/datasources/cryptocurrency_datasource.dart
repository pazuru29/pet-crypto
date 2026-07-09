import 'package:pet_crypto/features/dashboard/data/datasources/crypto_details_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_cryptocurrency_datasource.dart';

abstract interface class CryptocurrencyDatasource
    implements DashboardCryptocurrencyDatasource, CryptoDetailsDatasource {}
