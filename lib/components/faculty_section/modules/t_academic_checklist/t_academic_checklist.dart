import 'package:flutter/material.dart';

class TAcademicChecklist extends StatefulWidget {
  final String token;

  const TAcademicChecklist({super.key, required this.token});

  @override
  State<TAcademicChecklist> createState() => _TAcademicChecklistState();
}

class _TAcademicChecklistState extends State<TAcademicChecklist> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ACADMIC CHECKLIST'),
      ),
    );
  }
}
