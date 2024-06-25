import 'package:flutter/material.dart';

class TExplore extends StatefulWidget {
  final String token;
  const TExplore({super.key, required this.token});

  @override
  State<TExplore> createState() => _TExploreState();
}

class _TExploreState extends State<TExplore> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('T EXPLORE'),
      ),
    );
  }
}
