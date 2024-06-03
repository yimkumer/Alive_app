import 'package:alive_app/components/login/login.dart';
import 'package:alive_app/components/student_section/assignment.dart';
import 'package:alive_app/components/student_section/faqs.dart';
import 'package:alive_app/components/student_section/std_home.dart';
import 'package:alive_app/components/student_section/study_material.dart';
import 'package:alive_app/components/student_section/subjects.dart';
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
    'FAQs',
  ];

  final drawerIcons = [
    Icons.home_outlined,
    Icons.menu_book_sharp,
    Icons.sticky_note_2_outlined,
    Icons.note_alt_outlined,
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
        return const FAQ();

      default:
        return const std_home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          drawerItems[_selectedDrawerIndex],
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Settings'),
                    content: SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: _isDarkMode,
                      onChanged: (bool value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                      },
                    ),
                  );
                },
              );
            },
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Profile'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min, // Add this line
                      children: <Widget>[
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Text(
                            'Y',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const Text('Name'),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.logout, color: Colors.red),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                );
                              },
                              child: const Text('Logout',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text(
                'Y',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF030034),
                Color(0xFF040042),
                Color(0xFF06005B),
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/alivelogo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alive',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Digital Classrooms",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ...List.generate(drawerItems.length, (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: _selectedDrawerIndex == index
                        ? const Color(0xFFEEBBC2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(07.0),
                  ),
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(drawerIcons[index],
                        color: _selectedDrawerIndex == index
                            ? const Color(0xfff161b44)
                            : Colors.white,
                        size: 25),
                    title: Text(
                      drawerItems[index],
                      style: TextStyle(
                          color: _selectedDrawerIndex == index
                              ? const Color(0xFF161B44)
                              : Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedDrawerIndex = index;
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
