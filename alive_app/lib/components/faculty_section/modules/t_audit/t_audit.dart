import 'package:flutter/material.dart';

class TAudit extends StatefulWidget {
  final String token;
  const TAudit({super.key, required this.token});

  @override
  State<TAudit> createState() => _TAuditState();
}

class _TAuditState extends State<TAudit> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('T AUDIT'),
      ),
    );
  }
}
