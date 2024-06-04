import 'package:flutter/material.dart';

class std_home extends StatelessWidget {
  const std_home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Center(
              heightFactor: 3,
              child: Text(
                "Welcome to Digital Classroom!",
                style: TextStyle(
                    color: Color(0xFF131A40),
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0),
              ))
        ],
      ),
    );
  }
}
