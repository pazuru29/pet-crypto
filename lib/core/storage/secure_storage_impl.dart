import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_crypto/core/storage/secure_storage.dart';

class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage storage;

  const SecureStorageImpl({required this.storage});

  @override
  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await storage.deleteAll();
  }
}
