# Dart Chat Server

This project is a simple chat server implemented in Dart using WebSockets. It allows multiple clients to connect and exchange messages in real-time.

## Features

- WebSocket-based communication
- Support for multiple concurrent clients
- Real-time message broadcasting
- Basic logging functionality

## Prerequisites

To run this project, you need to have the following installed:

- Dart SDK (version 2.12 or later)
- Git (for version control)

## Setup

1. Clone the repository:

   ```
   git clone https://github.com/qharny/chat_server.git
   cd chat_server
   ```

2. Install dependencies:

   ```
   dart pub get
   ```

3. Run the server:

   ```
   dart run bin/server.dart
   ```

The server will start running on `ws://localhost:8080` by default.

## Project Structure

```txt
chat_server/
│
├── bin/
│   └── server.dart       # Main entry point for the server
│
├── lib/
│   ├── models/
│   │   └── message.dart  # Message model
│   │
│   ├── services/
│   │   └── socket_service.dart  # WebSocket handling
│   │
│   └── utils/
│       └── logger.dart   # Logging utility
│
├── test/
│   └── server_test.dart  # Tests for the server
│
├── pubspec.yaml          # Dart package manager file
└── README.md             # This file
```

## Usage

Once the server is running, clients can connect to it using a WebSocket client. Here's a simple example of how to connect and send messages using Dart:

```dart
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

void main() {
  final channel = IOWebSocketChannel.connect('ws://localhost:8080');
  
  channel.stream.listen((message) {
    final decodedMessage = jsonDecode(message);
    print('Received: ${decodedMessage['content']}');
  });

  channel.sink.add(jsonEncode({
    'sender': 'Client',
    'content': 'Hello, server!',
    'timestamp': DateTime.now().toIso8601String(),
  }));
}
```

## Testing

To run the tests:

```
dart test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).
