import 'package:flutter/material.dart';

class Academics extends StatefulWidget {
  final String token;
  const Academics({super.key, required this.token});

  @override
  State<Academics> createState() => _AcademicsState();
}

class _AcademicsState extends State<Academics> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Academics'),
      ),
    );
  }
}
