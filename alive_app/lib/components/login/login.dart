import 'package:alive_app/components/faculty_section/faculty.dart';
import 'package:alive_app/components/student_section/student.dart';
import 'package:alive_app/components/login/loading_screen.dart';
import 'package:alive_app/components/login/login_form.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  int _currentTabIndex = 0;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingScreen()
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  indicatorColor: const Color(0xFFF28F06),
                  tabs: const [
                    Tab(
                        child: Text('STUDENT',
                            style: TextStyle(
                                color: Color(0xFF2497EA), fontSize: 15))),
                    Tab(
                        child: Text('FACULTY',
                            style: TextStyle(
                                color: Color(0xFF2497EA), fontSize: 15))),
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                ),
              ),
              body: LoginForm(
                formKey: _formKey,
                usernameController: _usernameController,
                passwordController: _passwordController,
                onTogglePasswordVisibility: _togglePasswordVisibility,
                obscureText: _obscureText,
                onLogin: (username, password) {
                  if (username.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill up the fields!')),
                    );
                  } else if (username != 'test' || password != 'password') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid credentials')),
                    );
                  } else {
                    setState(() {
                      _isLoading = true;
                    });
                    Future.delayed(const Duration(seconds: 2), () {
                      if (_currentTabIndex == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Student()),
                        ).then((value) => setState(() {
                              _isLoading = false;
                            }));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Faculty()),
                        ).then((value) => setState(() {
                              _isLoading = false;
                            }));
                      }
                    });
                  }
                },
              ),
            ),
          );
  }
}
