import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/message.dart';
import '../utils/logger.dart';

final List<WebSocketChannel> _clients = [];

void handleWebSocket(WebSocketChannel socket) {
  _clients.add(socket);
  logger.i('Client connected. Total clients: ${_clients.length}');

  socket.stream.listen(
    (message) {
      try {
        final decodedMessage = jsonDecode(message);
        final chatMessage = Message.fromJson(decodedMessage);
        broadcastMessage(chatMessage);
      } catch (e) {
        logger.e('Error processing message: $e');
      }
    },
    onDone: () {
      _clients.remove(socket);
      logger.i('Client disconnected. Total clients: ${_clients.length}');
    },
    onError: (error) {
      logger.e('WebSocket error: $error');
      _clients.remove(socket);
    },
  );
}

void broadcastMessage(Message message) {
  final encodedMessage = jsonEncode(message.toJson());
  for (var client in _clients) {
    client.sink.add(encodedMessage);
  }
  logger.d('Broadcasted message: ${message.content}');
}