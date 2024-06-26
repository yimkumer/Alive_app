import 'package:flutter/material.dart';

class Ai extends StatefulWidget {
  final String token;
  const Ai({super.key, required this.token});

  @override
  State<Ai> createState() => _AiState();
}

class _AiState extends State<Ai> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('AI'),
      ),
    );
  }
}
