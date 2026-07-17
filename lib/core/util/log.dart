import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class Log {
  static void init() {
    if (!kDebugMode) {
      Logger.root.level = .OFF;
      return;
    }

    Logger.root.level = .ALL;

    Logger.root.onRecord.listen((record) {
      final buffer = StringBuffer()
        ..writeln(
          '${record.level.name} '
          '[${record.time.toIso8601String()}] '
          '${record.loggerName}:',
        )
        ..write(record.message);

      if (record.error != null) {
        buffer
          ..writeln()
          ..write('Error: ${record.error}');
      }

      if (record.stackTrace != null) {
        buffer
          ..writeln()
          ..writeln('Stack trace:')
          ..write(record.stackTrace);
      }

      debugPrint(buffer.toString(), wrapWidth: 1024);
    });
  }
}
