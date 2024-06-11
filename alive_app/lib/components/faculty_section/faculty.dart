import 'package:flutter/material.dart';

class Faculty extends StatelessWidget {
  const Faculty({super.key, required String token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Faculty Section'),
    ));
  }
}
