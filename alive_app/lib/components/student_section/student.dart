import 'package:alive_app/components/login/login.dart';
import 'package:alive_app/components/student_section/modules/academics/academics.dart';
import 'package:alive_app/components/student_section/modules/ai_tutor/ai.dart';
import 'package:alive_app/components/student_section/modules/assignment/assignment.dart';
import 'package:alive_app/components/student_section/modules/discussions/explore.dart';
import 'package:alive_app/components/student_section/modules/discussions/my_discussions.dart';
import 'package:alive_app/components/student_section/modules/exam/exams.dart';
import 'package:alive_app/components/student_section/modules/exam/scores.dart';
import 'package:alive_app/components/student_section/modules/faqs/faqs.dart';
import 'package:alive_app/components/student_section/modules/resume/resume.dart';
import 'package:alive_app/components/student_section/modules/homepage/std_home.dart';
import 'package:alive_app/components/student_section/modules/study_material/study_material.dart';
import 'package:alive_app/components/student_section/modules/subjects/subjects.dart';
import 'package:alive_app/components/student_section/custom_app_bar.dart';
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  final String token;

  const Student({super.key, required this.token});

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  bool _isDarkMode = false;
  int _selectedDrawerIndex = 0;

  final drawerItems = [
    'Home',
    'Subjects',
    'Materials',
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Success'),
          duration: Durations.medium4,
        ),
      );
    });
  }

  Widget _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return std_home(token: widget.token);
      case 1:
        return Subjects(token: widget.token);
      case 2:
        return StudyMaterial(token: widget.token);
      case 3:
        return Assignment(token: widget.token);
      case 4:
        return Exams(token: widget.token);
      case 5:
        return Scores(token: widget.token);
      case 6:
        return Explore(token: widget.token);
      case 7:
        return MyDiscussions(token: widget.token);
      case 8:
        return Resume(token: widget.token);
      case 9:
        return Ai(token: widget.token);
      case 10:
        return Academics(token: widget.token);
      case 11:
        return FAQ(token: widget.token);
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
        body: _getDrawerItemWidget(_selectedDrawerIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedDrawerIndex < 4 ? _selectedDrawerIndex : 4,
          items: [
            BottomNavigationBarItem(
                icon: Icon(drawerIcons[0]), label: drawerItems[0]),
            BottomNavigationBarItem(
                icon: Icon(drawerIcons[1]), label: drawerItems[1]),
            BottomNavigationBarItem(
                icon: Icon(drawerIcons[2]), label: drawerItems[2]),
            BottomNavigationBarItem(
                icon: Icon(drawerIcons[3]), label: drawerItems[3]),
            const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view), label: 'Menu'),
          ],
          onTap: (index) {
            if (index < 4) {
              setState(() {
                _selectedDrawerIndex = index;
              });
            } else {
              _showGridMenu(context);
            }
          },
          elevation: 8.0,
          selectedItemColor: Colors.blue,
        ),
      ),
    );
  }

  void _showGridMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        double gridHeight = MediaQuery.of(context).size.height * 0.5;

        return SizedBox(
          height: gridHeight,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: GridView.builder(
              itemCount: drawerItems.length - 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                int itemIndex = index + 4;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDrawerIndex = itemIndex;
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(drawerIcons[itemIndex], size: 38),
                        Text(drawerItems[itemIndex],
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
