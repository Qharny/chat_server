import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  late Process server;
  late WebSocket socket;

  setUp(() async {
    // Start the server
    server = await Process.start('dart', ['bin/cha_server.dart']);
    // Wait for the server to start
    await Future.delayed(Duration(seconds: 2));
    // Connect to the server
    socket = await WebSocket.connect('ws://localhost:8080');
  });

  tearDown(() async {
    // Close the WebSocket connection
    await socket.close();
    // Kill the server process
    server.kill();
  });

  test('Server echoes messages', () async {
    final message = {'sender': 'Test', 'content': 'Hello, World!', 'timestamp': DateTime.now().toIso8601String()};
    socket.add(jsonEncode(message));

    expect(socket.first.then((response) => jsonDecode(response as String)),
      completion(containsPair('content', 'Hello, World!')));
  });
}
