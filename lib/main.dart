// main.dart
import 'package:basil_machine/websocket.dart';
import 'package:flutter/material.dart';

import 'api.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter API Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to API Call Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApiCallPage()),
                );
              },
              child: Text('API Calls'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to WebSocket Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebSocketPage()),
                );
              },
              child: Text('WebSockets'),
            ),
          ],
        ),
      ),
    );
  }
}
