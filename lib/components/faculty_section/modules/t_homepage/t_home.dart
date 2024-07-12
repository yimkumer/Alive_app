import 'package:alive_app/components/faculty_section/modules/t_homepage/t_calendar.dart';
import 'package:alive_app/components/faculty_section/modules/t_homepage/t_discussions.dart';
import 'package:alive_app/components/faculty_section/modules/t_homepage/t_semsubjects.dart';
import 'package:flutter/material.dart';

import 't_profile_section.dart';

class THome extends StatelessWidget {
  final String token;

  const THome({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TProfileSection(
              token: token,
            ),
            TCalendar(token: token),
            TSemsubjects(token: token),
            const TDiscussions(),
          ],
        ),
      ),
    );
  }
}
