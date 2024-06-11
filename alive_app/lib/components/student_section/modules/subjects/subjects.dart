import 'package:flutter/material.dart';

class Subjects extends StatefulWidget {
  final String token;
  const Subjects({super.key, required this.token});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  @override
  void initState() {
    super.initState();
    print('Token: ${widget.token}');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [Center(child: Text("SUBJECTS PAGE"))],
      ),
    );
  }
}
