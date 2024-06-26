import 'package:flutter/material.dart';

class TExams extends StatefulWidget {
  final String token;

  const TExams({super.key, required this.token});

  @override
  State<TExams> createState() => _TExamsState();
}

class _TExamsState extends State<TExams> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('T EXAMS'),
      ),
    );
  }
}
