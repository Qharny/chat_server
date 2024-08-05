import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  late Process server;
  IOWebSocketChannel? channel;

  setUp(() async {
    // Start the server
    server = await Process.start('dart', ['bin/server.dart']);
    print('Starting server...');

    // Print server output for debugging
    server.stdout.transform(utf8.decoder).listen((data) {
      print('Server output: $data');
    });
    server.stderr.transform(utf8.decoder).listen((data) {
      print('Server error: $data');
    });

    // Wait for the server to start
    await Future.delayed(Duration(seconds: 5));
    print('Attempting to connect to server...');

    // Try to connect to the server
    try {
      channel = IOWebSocketChannel.connect('ws://localhost:8080');
      print('Connected to server');
    } catch (e) {
      print('Failed to connect to server: $e');
      rethrow;
    }
  });

  tearDown(() async {
    // Close the WebSocket connection
    await channel?.sink.close();
    // Kill the server process
    print('Shutting down server...');
    server.kill();
  });

  test('Server echoes messages', () async {
    expect(channel, isNotNull);

    final message = {'sender': 'Test', 'content': 'Hello, World!', 'timestamp': DateTime.now().toIso8601String()};
    channel!.sink.add(jsonEncode(message));

    expect(
      channel!.stream.map((response) => jsonDecode(response as String)).first,
      completion(containsPair('content', 'Hello, World!')),
    );
  });
}