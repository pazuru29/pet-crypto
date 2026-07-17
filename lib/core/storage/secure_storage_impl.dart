import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/storage/secure_storage.dart';

class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage storage;

  const SecureStorageImpl({required this.storage});

  @override
  Future<String?> read(String key) async {
    try {
      return await storage.read(key: key);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageException(
          technicalMessage: 'Failed to read secure storage value',
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await storage.write(key: key, value: value);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageException(
          technicalMessage: 'Failed to write secure storage value',
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await storage.delete(key: key);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageException(
          technicalMessage: 'Failed to delete secure storage value',
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await storage.deleteAll();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        StorageException(
          technicalMessage: 'Failed to delete all secure storage values',
          cause: error,
        ),
        stackTrace,
      );
    }
  }
}
