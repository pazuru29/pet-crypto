import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/util/app_storage_keys.dart';

import 'in_memory_preferences_storage.dart';

void main() {
  late InMemoryPreferencesStorage storage;

  group('Class InMemoryPreferencesStorage', () {
    final String initialIntKey = 'some-key-int';
    final String initialStringKey = 'some-key-string';
    final Map<String, Object> initialValues = {
      initialIntKey: 1,
      initialStringKey: 'Result',
    };

    setUp(() {
      storage = InMemoryPreferencesStorage(initialValues: initialValues);
    });

    group('parameter initialValues', () {
      test(
        'change initialValues don\'t change values inside InMemoryPreferencesStorage',
        () {
          final Map<String, Object> valuest = {};
          storage = InMemoryPreferencesStorage(initialValues: valuest);

          final key = 'some-new-key-string';
          final value = 'new-value';

          valuest.putIfAbsent(key, () => value);
          expect(valuest[key], value);

          final result = storage.getString(key);
          expect(result, isNull);
        },
      );
    });

    group('method getInt', () {
      test('should return null for non-existent key', () {
        final key = 'non-existent-some-key';
        final result = storage.getInt(key);
        expect(result, isNull);
      });

      test('should return int for existing key', () {
        final result = storage.getInt(initialIntKey);
        expect(result, 1);
      });

      test('should throw TypeError if value is not int', () {
        final call = storage.getInt;
        expect(() => call(initialStringKey), throwsA(isA<TypeError>()));
      });
    });

    group('method getString', () {
      test('should return null for non-existent key', () {
        final key = 'non-existent-some-key';
        final result = storage.getString(key);
        expect(result, isNull);
      });

      test('should return String for existing key', () {
        final result = storage.getString(initialStringKey);
        expect(result, 'Result');
      });

      test('should throw TypeError if value is not String', () {
        final call = storage.getString;
        expect(() => call(initialIntKey), throwsA(isA<TypeError>()));
      });
    });

    group('method setInt', () {
      test('should set new int with new key', () async {
        final key = 'new-some-key-int';
        await storage.setInt(key, 2);
        final result = storage.getInt(key);
        expect(result, 2);
      });

      test('should set new int to exist key', () async {
        await storage.setInt(initialIntKey, 2);
        final result = storage.getInt(initialIntKey);
        expect(result, 2);
      });
    });

    group('method setString', () {
      test('should set new String with new key', () async {
        final key = 'new-some-key-string';
        await storage.setString(key, 'Result-2');
        final result = storage.getString(key);
        expect(result, 'Result-2');
      });

      test('should set new String to exist key', () async {
        await storage.setString(initialStringKey, 'Result-2');
        final result = storage.getString(initialStringKey);
        expect(result, 'Result-2');
      });
    });

    group('method remove', () {
      test('should remove existing key', () async {
        await storage.remove(initialStringKey);
        final result = storage.getString(initialStringKey);
        expect(result, isNull);
      });

      test(
        'should do nothing and correct finish with non-existent key',
        () async {
          final key = 'some-non-existent-key';
          await storage.remove(key);
          final result = storage.getString(key);
          expect(result, isNull);
        },
      );
    });
  });

  group('Class InMemoryPreferencesStorage', () {
    group('integration with S', () {
      late S localeProvider;

      setUp(() {
        storage = InMemoryPreferencesStorage(
          initialValues: {AppStorageKeys.locale: 'uk'},
        );
        localeProvider = S(storage: storage)..init();
      });

      test('should set to locale uk', () {
        expect(localeProvider.locale.languageCode, 'uk');
      });

      test('should set to locale en', () async {
        await localeProvider.setLocale('en');
        final result = storage.getString(AppStorageKeys.locale);
        expect(localeProvider.locale.languageCode, 'en');
        expect(result, 'en');
      });
    });

    group('integration with AppThemeProvider', () {
      late AppThemeProvider themeProvider;

      setUp(() {
        storage = InMemoryPreferencesStorage(
          initialValues: {AppStorageKeys.themeMode: 2},
        );
        themeProvider = AppThemeProvider(storage: storage)..init();
      });

      test('should set to mode dark', () {
        expect(themeProvider.mode, ThemeMode.dark);
      });

      test('should set to mode system', () async {
        await themeProvider.setMode(0);
        final result = storage.getInt(AppStorageKeys.themeMode);
        expect(themeProvider.mode, ThemeMode.system);
        expect(result, 0);
      });
    });
  });
}
