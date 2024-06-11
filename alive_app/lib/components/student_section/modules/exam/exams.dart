import 'package:flutter/material.dart';

class Exams extends StatefulWidget {
  final String token;
  const Exams({super.key, required this.token});

  @override
  State<Exams> createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {
  @override
  void initState() {
    super.initState();
    print('Token: ${widget.token}');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Exams'),
      ),
    );
  }
}
