import 'package:flutter/material.dart';
import 'leaderboard.dart';
import 'profile_section.dart';
import 'academic_progress.dart';

class std_home extends StatelessWidget {
  final String token;

  const std_home({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileSection(),
            AcademicProgress(),
            Leaderboard(),
          ],
        ),
      ),
    );
  }
}
