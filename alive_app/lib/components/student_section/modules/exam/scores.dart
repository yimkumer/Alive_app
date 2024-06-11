import 'package:flutter/material.dart';

class Scores extends StatefulWidget {
  final String token;
  const Scores({super.key, required this.token});

  @override
  State<Scores> createState() => _ScoresState();
}

class _ScoresState extends State<Scores> {
  @override
  void initState() {
    super.initState();
    print('Token: ${widget.token}');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Scores'),
      ),
    );
  }
}
