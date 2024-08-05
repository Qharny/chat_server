import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  final channel = IOWebSocketChannel.connect('ws://localhost:8080');
  
  print('Connected to server. Type a message and press enter to send.');
  print('Type "exit" to quit.');

  // Listen for messages from the server
  channel.stream.listen((message) {
    final decodedMessage = jsonDecode(message);
    print('${decodedMessage['sender']}: ${decodedMessage['content']}');
  });

  // Send messages to the server
  while (true) {
    String? input = stdin.readLineSync();
    if (input?.toLowerCase() == 'exit') break;
    
    final message = {
      'sender': 'Client',
      'content': input,
      'timestamp': DateTime.now().toIso8601String(),
    };
    channel.sink.add(jsonEncode(message));
  }

  // Close the connection
  channel.sink.close();
}