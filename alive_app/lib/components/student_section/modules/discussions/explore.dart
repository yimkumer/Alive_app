import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  final String token;
  const Explore({super.key, required this.token});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  void initState() {
    super.initState();
    print('Token: ${widget.token}');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Explore'),
      ),
    );
  }
}
