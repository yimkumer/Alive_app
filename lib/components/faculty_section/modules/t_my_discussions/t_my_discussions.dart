import 'package:flutter/material.dart';

class TMyDiscussions extends StatefulWidget {
  final String token;
  const TMyDiscussions({super.key, required this.token});

  @override
  State<TMyDiscussions> createState() => _TMyDiscussionsState();
}

class _TMyDiscussionsState extends State<TMyDiscussions> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('T MY DISCUSSIONS'),
      ),
    );
  }
}
