import 'package:flutter/material.dart';
import 'calendar.dart';
import 'leaderboard.dart';
import 'profile_section.dart';
import 'academic_progress.dart';
import 'semsubjects.dart';

class std_home extends StatelessWidget {
  final String token;

  const std_home({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileSection(),
            const AcademicProgress(),
            const Leaderboard(),
            const Calendar(),
            Semsubjects(token: token),
          ],
        ),
      ),
    );
  }
}
