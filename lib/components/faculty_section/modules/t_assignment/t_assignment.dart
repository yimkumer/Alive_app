import 'package:flutter/material.dart';

class TAssignment extends StatefulWidget {
  final String token;

  const TAssignment({super.key, required this.token});

  @override
  State<TAssignment> createState() => _TAssignmentState();
}

class _TAssignmentState extends State<TAssignment> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('T Assignment'),
      ),
    );
  }
}
