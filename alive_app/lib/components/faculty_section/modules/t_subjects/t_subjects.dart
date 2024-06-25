import 'package:flutter/material.dart';

class TSubjects extends StatefulWidget {
  final String token;

  const TSubjects({super.key, required this.token});

  @override
  State<TSubjects> createState() => _TSubjectsState();
}

class _TSubjectsState extends State<TSubjects> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('T SUBJECTS'),
      ),
    );
  }
}
