import 'package:flutter/material.dart';

class TFaq extends StatefulWidget {
  final String token;
  const TFaq({super.key, required this.token});

  @override
  State<TFaq> createState() => _TFaqState();
}

class _TFaqState extends State<TFaq> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('T FAQ'),
      ),
    );
  }
}
