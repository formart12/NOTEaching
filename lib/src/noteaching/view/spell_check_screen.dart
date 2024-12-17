import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spell Check App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SpellCheckScreen(),
    );
  }
}

class SpellCheckScreen extends StatefulWidget {
  const SpellCheckScreen({super.key});

  @override
  _SpellCheckScreenState createState() => _SpellCheckScreenState();
}

class _SpellCheckScreenState extends State<SpellCheckScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  // Function to check spelling and grammar using LanguageTool API
  Future<void> _checkSpellingAndGrammar(String text) async {
    if (text.trim().isEmpty) {
      setState(() {
        _result = 'Please enter some text.';
      });
      return;
    }

    final url = Uri.parse('https://api.languagetool.org/v2/check');
    try {
      final body = {
        'text': Uri.encodeComponent(text),
        'language': 'ko', // Set language to Korean ('ko')
        'enabledOnly': 'false',
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['matches'].isEmpty) {
          setState(() {
            _result = 'No spelling or grammar issues found.';
          });
        } else {
          setState(() {
            _result = 'Errors found: \n';
            for (var match in result['matches']) {
              _result += '${match['message']}\n';
            }
          });
        }
      } else {
        setState(() {
          _result =
              'Failed to check spelling or grammar. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Korean Spell Check App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter text to check spelling and grammar (Korean):',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter text here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _checkSpellingAndGrammar(_controller.text);
              },
              child: const Text('Check Spelling & Grammar'),
            ),
            const SizedBox(height: 16),
            if (_result.isNotEmpty)
              Text(
                'Result: $_result',
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
