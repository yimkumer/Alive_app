import 'package:flutter/material.dart';

class Resume extends StatefulWidget {
  final String token;

  const Resume({super.key, required this.token});

  @override
  State<Resume> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  @override
  void initState() {
    super.initState();
    print('Token: ${widget.token}');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Resume'),
      ),
    );
  }
}
