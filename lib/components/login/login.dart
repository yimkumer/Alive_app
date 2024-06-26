import 'dart:io';
import 'package:alive_app/components/faculty_section/faculty.dart';
import 'package:alive_app/components/login/loading_screen.dart';
import 'package:alive_app/components/student_section/student.dart';
import 'package:alive_app/components/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<Map<String, dynamic>> login(
      String username, String password, String userType) async {
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode(
        {"username": username, "password": password, "usertype": userType});
    try {
      var response = await http.post(
        Uri.parse('https://api.alive.university/api/v1/login/erp'),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }
}

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
  final AuthService _authService = AuthService();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logow.png',
                    fit: BoxFit.contain,
                    height: 70,
                    width: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Alive',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 38,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Center(
              child: Card(
                elevation: 1,
                child: IntrinsicWidth(
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(08),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF66B4D),
                          Color(0xFFE65E65),
                          Color(0xFFCC468C),
                        ],
                      ),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Student',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Faculty',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                    onTap: (index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: LoginForm(
                formKey: _formKey,
                usernameController: _usernameController,
                passwordController: _passwordController,
                onTogglePasswordVisibility: _togglePasswordVisibility,
                obscureText: _obscureText,
                onLogin: (username, password) async {
                  if (username.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill up the fields!'),
                        duration: Durations.long1,
                      ),
                    );
                  } else {
                    try {
                      var jsonResponse = await _authService.login(
                          username,
                          password,
                          _currentTabIndex == 0 ? "STUDENT" : "FACULTY");
                      String token = jsonResponse['token'];
                      if (jsonResponse['status'] == true) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return const LoadingScreen();
                          },
                        );

                        await Future.delayed(const Duration(seconds: 3));

                        Navigator.pop(context);

                        if (_currentTabIndex == 0) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Student(token: token)),
                          );
                        } else if (_currentTabIndex == 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Faculty(token: token)),
                          );
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.toString()),
                        duration: Durations.long1,
                      ));
                    }
                  }
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
