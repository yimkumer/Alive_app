import 'package:flutter/material.dart';

class Assignment extends StatefulWidget {
  final String token;
  const Assignment({super.key, required this.token});

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [Center(child: Text("Assignment Page"))],
      ),
    );
  }
}
