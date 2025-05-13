import 'package:flutter/material.dart';

class DetailResultScreen extends StatelessWidget {
  final String title;
  final List<dynamic> words;

  const DetailResultScreen({
    super.key,
    required this.title,
    required this.words,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xffdea7db),
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (_, index) {
          final word = words[index];
          return ListTile(title: Text(word.word ?? ''));
        },
      ),
    );
  }
}
