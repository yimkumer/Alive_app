import 'package:flutter/material.dart';
import 'welcome_text.dart';
import 'profile_section.dart';
import 'academic_progress.dart';

class std_home extends StatelessWidget {
  const std_home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            WelcomeText(),
            ProfileSection(),
            AcademicProgress(),
          ],
        ),
      ),
    );
  }
}
