import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      heightFactor: 3,
      child: Text(
        "Welcome to Digital Classroom!",
        style: TextStyle(
          color: Color(0xFF131A40),
          fontWeight: FontWeight.w500,
          fontSize: 15.0,
        ),
      ),
    );
  }
}
