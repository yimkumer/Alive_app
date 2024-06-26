import 'package:flutter/material.dart';

class TStudyMaterial extends StatefulWidget {
  final String token;

  const TStudyMaterial({super.key, required this.token});

  @override
  State<TStudyMaterial> createState() => _TStudyMaterialState();
}

class _TStudyMaterialState extends State<TStudyMaterial> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('T STUDY MATERIAL'),
      ),
    );
  }
}
