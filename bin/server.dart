// import 'dart:io';
// import 'package:chat_server/services/service.dart';
// import 'package:chat_server/utils/logger.dart';
// import 'package:shelf/shelf.dart' as shelf;
// import 'package:shelf/shelf_io.dart' as io;
// import 'package:shelf_web_socket/shelf_web_socket.dart';

// void main() async {
//   final port = int.parse(Platform.environment['PORT'] ?? '8080');
//   final handler = webSocketHandler((webSocket) {
//     handleWebSocket(webSocket);
//   });

//   final server = await io.serve(handler, InternetAddress.anyIPv4, port);
//   logger.i('Serving at ws://${server.address.host}:${server.port}');
// }

import 'dart:io';
import 'package:chat_server/services/service.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import '../lib/utils/logger.dart';

void main() async {
  initializeLogger();
  
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final handler = webSocketHandler((webSocket) {
    handleWebSocket(webSocket);
  });

  try {
    final server = await io.serve(handler, InternetAddress.anyIPv4, port);
    logger.i('Serving at ws://${server.address.host}:${server.port}');
  } catch (e) {
    logger.e('Failed to start server: $e');
    exit(1);
  }
}