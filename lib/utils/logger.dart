import 'package:logging/logging.dart';

final logger = Logger('ChatServer');

void initializeLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

// Extension methods for easier logging
extension LoggerExtension on Logger {
  void i(String message) => info(message);
  void e(String message) => severe(message);
  void w(String message) => warning(message);
  void d(String message) => fine(message);
}