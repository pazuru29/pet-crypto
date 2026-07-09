import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class Log {
  static void init() {
    if (kDebugMode) {
      Logger.root.level = .ALL;
    } else {
      Logger.root.level = .OFF;
    }

    Logger.root.onRecord.listen((record) {
      debugPrint(
        '${record.level.name} [${record.time.toIso8601String()}]:\n${record.message}',
        wrapWidth: 1024,
      );
    });
  }
}
