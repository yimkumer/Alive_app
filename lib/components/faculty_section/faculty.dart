import 'package:flutter/material.dart';
import 'package:alive_app/components/login/login.dart';
import 'custom_app_bar_t.dart';
import 'modules/t_academic_checklist/t_academic_checklist.dart';
import 'modules/t_assignment/t_assignment.dart';
import 'modules/t_audit/t_audit.dart';
import 'modules/t_exams/t_exams.dart';
import 'modules/t_explore/t_explore.dart';
import 'modules/t_faq/t_faq.dart';
import 'modules/t_homepage/t_home.dart';
import 'modules/t_my_discussions/t_my_discussions.dart';
import 'modules/t_participations/t_participations.dart';
import 'modules/t_study_material/t_study_material.dart';
import 'modules/t_subjects/t_subjects.dart';

class Faculty extends StatefulWidget {
  final String token;

  const Faculty({super.key, required this.token});

  @override
  State<Faculty> createState() => _FacultyState();
}

class _FacultyState extends State<Faculty> {
  bool _isDarkMode = false;
  int _selectedDrawerIndex = 0;

  final drawerItems = [
    'Home',
    'Subjects',
    'Materials',
    'Assignment',
    'Academic Checklist',
    'Audit',
    'Exams',
    'Participations',
    'Explore',
    'My Discussions',
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
    Icons.question_mark_sharp,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Success'),
          duration: Durations.extralong1,
        ),
      );
    });
  }

  Widget _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return THome(token: widget.token);
      case 1:
        return TSubjects(token: widget.token);
      case 2:
        return TStudyMaterial(token: widget.token);
      case 3:
        return TAssignment(token: widget.token);
      case 4:
        return TAcademicChecklist(token: widget.token);
      case 5:
        return TAudit(token: widget.token);
      case 6:
        return TExams(token: widget.token);
      case 7:
        return TParticipations(token: widget.token);
      case 8:
        return TExplore(token: widget.token);
      case 9:
        return TMyDiscussions(token: widget.token);
      case 10:
        return TFaq(token: widget.token);

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
          elevation: 1.0,
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
                crossAxisCount: 3,
              ),
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
                        Icon(drawerIcons[itemIndex], size: 30),
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
