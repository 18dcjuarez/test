import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_api/models/entry_model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: APITestPage(),
    );
  }
}

class APITestPage extends StatefulWidget {
  @override
  _APITestPageState createState() => _APITestPageState();
}

class _APITestPageState extends State<APITestPage> {
  String _apiResponse = '';
  final url = 'https://api.publicapis.org/entries';
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<EntryModel> auxL = [];
        data['entries'].map((e) => auxL.add(EntryModel.fromJson(e))).toList();

        setState(() {
          _apiResponse = auxL[0].description.toString();
          isLoading = false;
        });
      } else {
        setState(() {
          _apiResponse = 'Error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _apiResponse = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> postData() async {
    setState(() => isLoading = true);
    try {
      final response =
          await http.post(Uri.parse('$url/post'), body: {'name': 'David'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _apiResponse = data;
          isLoading = false;
        });
      } else {
        setState(() {
          _apiResponse = 'Error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _apiResponse = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchData,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Fetch Data'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: postData,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('POST'),
            ),
            const SizedBox(height: 16),
            Text(
              _apiResponse,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
