import 'package:flutter/material.dart';

class MyDiscussions extends StatefulWidget {
  final String token;
  const MyDiscussions({super.key, required this.token});

  @override
  State<MyDiscussions> createState() => _MyDiscussionsState();
}

class _MyDiscussionsState extends State<MyDiscussions> {
  @override
  void initState() {
    super.initState();
    print('Token: ${widget.token}');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('My Discussions'),
      ),
    );
  }
}
