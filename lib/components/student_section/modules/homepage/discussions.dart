import 'package:flutter/material.dart';

class Discussions extends StatelessWidget {
  const Discussions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 0, 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Discussions",
              style: TextStyle(
                color: Color(0xFF05004E),
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
