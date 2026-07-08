import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:pet_crypto/core/util/app_storage_keys.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_local_datasource.dart';

class DashboardLocalDatasourceImpl implements DashboardLocalDatasource {
  final PreferencesStorage preferencesStorage;

  DashboardLocalDatasourceImpl({required this.preferencesStorage});

  @override
  String? fetchUserImage() {
    return preferencesStorage.getString(AppStorageKeys.imageKey);
  }
}
