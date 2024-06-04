import 'package:alive_app/components/login/login.dart';
import 'package:alive_app/components/student_section/modules/academics.dart';
import 'package:alive_app/components/student_section/modules/ai.dart';
import 'package:alive_app/components/student_section/modules/assignment.dart';
import 'package:alive_app/components/student_section/modules/discussions/explore.dart';
import 'package:alive_app/components/student_section/modules/discussions/my_discussions.dart';
import 'package:alive_app/components/student_section/modules/exam/exams.dart';
import 'package:alive_app/components/student_section/modules/exam/scores.dart';
import 'package:alive_app/components/student_section/modules/faqs.dart';
import 'package:alive_app/components/student_section/modules/resume.dart';
import 'package:alive_app/components/student_section/modules/std_home.dart';
import 'package:alive_app/components/student_section/modules/study_material.dart';
import 'package:alive_app/components/student_section/modules/subjects.dart';
import 'package:alive_app/components/student_section/custom_app_bar.dart';
import 'package:alive_app/components/student_section/custom_drawer.dart';
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  bool _isDarkMode = false;
  int _selectedDrawerIndex = 0;

  final drawerItems = [
    'Home',
    'Subjects',
    'Study Material',
    'Assignment',
    'Exams',
    'Scores',
    'Explore-Discussions',
    'My Discussions',
    'Resume Builder',
    'AI Tutor',
    'Academics',
    'FAQs',
  ];

  final drawerIcons = [
    Icons.home_outlined,
    Icons.menu_book_sharp,
    Icons.sticky_note_2_outlined,
    Icons.note_alt_outlined,
    Icons.assignment,
    Icons.school_outlined,
    Icons.people_outline,
    Icons.mark_chat_read_outlined,
    Icons.spatial_tracking_outlined,
    Icons.person_pin_outlined,
    Icons.cyclone_sharp,
    Icons.question_mark_sharp,
  ];

  Widget _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const std_home();
      case 1:
        return const Subjects();
      case 2:
        return const StudyMaterial();
      case 3:
        return const Assignment();
      case 4:
        return const Exams();
      case 5:
        return const Scores();
      case 6:
        return const Explore();
      case 7:
        return const MyDiscussions();
      case 8:
        return const Resume();
      case 9:
        return const Ai();
      case 10:
        return const Academics();
      case 11:
        return const FAQ();
      default:
        return const Text('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode
          ? ThemeData(
              primaryColor: Colors.white,
              colorScheme: const ColorScheme.dark()
                  .copyWith(secondary: Colors.white)
                  .copyWith(surface: Colors.black),
            )
          : ThemeData(
              primaryColor: Colors.grey[800],
              colorScheme: const ColorScheme.light()
                  .copyWith(secondary: Colors.grey[400])
                  .copyWith(surface: Colors.white),
            ),
      child: Scaffold(
        appBar: CustomAppBar(
          isDarkMode: _isDarkMode,
          selectedDrawerIndex: _selectedDrawerIndex,
          drawerItems: drawerItems,
          onDarkModeToggle: (value) {
            setState(() {
              _isDarkMode = value;
            });
          },
          onLogout: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const Login();
            }), (r) {
              return false;
            });
          },
        ),
        drawer: CustomDrawer(
          selectedDrawerIndex: _selectedDrawerIndex,
          drawerItems: drawerItems,
          drawerIcons: drawerIcons,
          onItemSelected: (index) {
            setState(() {
              _selectedDrawerIndex = index;
            });
          },
        ),
        body: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
    );
  }
}
