import 'package:flutter/material.dart';

class TParticipations extends StatefulWidget {
  final String token;

  const TParticipations({super.key, required this.token});

  @override
  State<TParticipations> createState() => _TParticipationsState();
}

class _TParticipationsState extends State<TParticipations> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('T PARTICIPATIONS'),
      ),
    );
  }
}
