import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Demo',
      home: ApiCallPage(),
    );
  }
}

class ApiCallPage extends StatefulWidget {
  @override
  _ApiCallPageState createState() => _ApiCallPageState();
}

class _ApiCallPageState extends State<ApiCallPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  List<Map<String, String>> headersList = [{'key': '', 'value': ''}];
  String _selectedMethod = 'GET';
  String _response = 'Response will appear here';

  // Function to handle API call
  Future<void> _makeApiCall() async {
    String url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _response = 'URL cannot be empty';
      });
      return;
    }

    // Create headers map from the list of header key-value pairs
    Map<String, String> headers = {};
    for (var header in headersList) {
      if (header['key']!.isNotEmpty && header['value']!.isNotEmpty) {
        headers[header['key']!] = header['value']!;
      }
    }

    try {
      http.Response response;
      if (_selectedMethod == 'GET') {
        response = await http.get(Uri.parse(url), headers: headers);
      } else if (_selectedMethod == 'POST') {
        response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: _bodyController.text.isNotEmpty ? json.encode(_bodyController.text) : null,
        );
      } else {
        throw UnsupportedError('Method not supported');
      }

      if (response.statusCode == 200) {
        setState(() {
          _response = 'Response: ${response.body}';
        });
      } else {
        setState(() {
          _response = 'Error: ${response.statusCode}';
        });
      }
    } on SocketException {
      // Handle offline mode
      setState(() {
        _response = 'Offline: Fetching local data';
      });
      _fetchLocalApi(url);
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  // Mock function for local API
  void _fetchLocalApi(String url) {
    if (url.contains('local')) {
      setState(() {
        _response = json.encode({'message': 'This is local data'});
      });
    } else {
      setState(() {
        _response = 'Local API not available for this URL';
      });
    }
  }

  // Function to add a new header row
  void _addHeaderField() {
    setState(() {
      headersList.add({'key': '', 'value': ''});
    });
  }

  // Function to remove a header row
  void _removeHeaderField(int index) {
    setState(() {
      headersList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Call Demo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // URL input
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'Enter API URL',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Method selection
              DropdownButton<String>(
                value: _selectedMethod,
                items: <String>['GET', 'POST'].map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (String? newMethod) {
                  setState(() {
                    _selectedMethod = newMethod!;
                  });
                },
              ),
              SizedBox(height: 20),

              // Dynamic headers section with key-value pairs
              Text('Headers:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Column(
                children: headersList.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, String> header = entry.value;

                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Header Key',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              headersList[index]['key'] = value;
                            });
                          },
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Header Value',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              headersList[index]['value'] = value;
                            });
                          },
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          _removeHeaderField(index);
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addHeaderField,
                child: Text('Add Header'),
              ),
              SizedBox(height: 20),

              // Body input
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: 'Body (for POST)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Send Button
              ElevatedButton(
                onPressed: _makeApiCall,
                child: Text('Send'),
              ),
              SizedBox(height: 20),

              // Response display
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
                    _response,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
