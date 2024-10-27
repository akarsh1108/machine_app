// websocket_page.dart
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final TextEditingController _channelController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _bindEventController = TextEditingController();
  WebSocketChannel? _channel;
  String _receivedMessage = 'Messages will appear here';
  String _boundEvent = '';

  // Function to connect to the WebSocket
  void _connectWebSocket() {
    String url = _channelController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _receivedMessage = 'WebSocket URL cannot be empty';
      });
      return;
    }

    // Connect to the WebSocket
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen((message) {
      // Check if the received message matches the bound event
      if (_boundEvent.isNotEmpty && message.contains(_boundEvent)) {
        setState(() {
          _receivedMessage = 'Event "$_boundEvent" received: $message';
        });
      }
    });
  }

  // Function to send a message
  void _sendMessage() {
    if (_channel != null && _messageController.text.isNotEmpty) {
      _channel!.sink.add(_messageController.text);
    }
  }

  // Function to bind to a specific event
  void _bindToEvent() {
    setState(() {
      _boundEvent = _bindEventController.text.trim();
      _receivedMessage = 'Listening for "$_boundEvent" events';
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSockets'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // WebSocket URL input
            TextField(
              controller: _channelController,
              decoration: InputDecoration(
                labelText: 'Enter WebSocket URL',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _connectWebSocket,
              child: Text('Connect'),
            ),
            SizedBox(height: 20),

            // Message sending form
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message to Send',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
            SizedBox(height: 40),

            // Event binding form
            TextField(
              controller: _bindEventController,
              decoration: InputDecoration(
                labelText: 'Event to Bind',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bindToEvent,
              child: Text('Bind to Event'),
            ),
            SizedBox(height: 20),

            // Display received message
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _receivedMessage,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
