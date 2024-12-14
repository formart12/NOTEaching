import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpellCheckScreen extends StatefulWidget {
  const SpellCheckScreen({super.key});

  @override
  _SpellCheckScreenState createState() => _SpellCheckScreenState();
}

class _SpellCheckScreenState extends State<SpellCheckScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  // 맞춤법 검사 함수
  Future<void> _checkSpelling(String text) async {
    final url = Uri.parse('https://speller.cs.pusan.ac.kr/results/');

    try {
      final response = await http.post(url, body: {'text': text});

      // 확인을 위한 디버깅
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // 실제 API에서의 결과 구조에 맞게 수정해야 할 수 있음
        final result = json.decode(response.body);

        // 응답 데이터가 예상대로인지 확인
        print('Decoded result: $result');

        setState(() {
          _result = result.toString(); // 여기에 필요한 데이터만 사용하세요.
        });
      } else {
        setState(() {
          _result = '맞춤법 검사에 실패했습니다.';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _result = '오류가 발생했습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spell Check'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '입력한 텍스트를 확인하세요:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '텍스트를 입력하세요...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _checkSpelling(_controller.text);
              },
              child: const Text('맞춤법 검사하기'),
            ),
            const SizedBox(height: 16),
            if (_result.isNotEmpty)
              Text(
                '검사 결과: $_result',
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
