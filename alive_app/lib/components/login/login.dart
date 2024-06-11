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
    var request = http.Request(
        'POST', Uri.parse('https://api.alive.university/api/v1/login/erp'));
    request.body = json.encode(
        {"username": username, "password": password, "usertype": userType});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(await response.stream.bytesToString());
      return jsonResponse;
    } else {
      throw Exception('Failed to connect to the server');
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
  late BuildContext localContext;
  int _currentTabIndex = 0;

  final AuthService _authService = AuthService();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    localContext = context;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: const Color(0xFFF28F06),
            tabs: const [
              Tab(
                  child: Text('STUDENT',
                      style:
                          TextStyle(color: Color(0xFF2497EA), fontSize: 15))),
              Tab(
                  child: Text('FACULTY',
                      style:
                          TextStyle(color: Color(0xFF2497EA), fontSize: 15))),
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
          onLogin: (username, password) async {
            if (username.isEmpty || password.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill up the fields!')),
              );
            } else {
              try {
                var jsonResponse = await _authService.login(username, password,
                    _currentTabIndex == 0 ? "STUDENT" : "FACULTY");
                String token = jsonResponse['token'];

                if (jsonResponse['status'] == true) {
                  Navigator.push(
                    localContext,
                    MaterialPageRoute(
                        builder: (context) => const LoadingScreen()),
                  );

                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await Future.delayed(const Duration(seconds: 3));

                    Navigator.pop(localContext);

                    if (_currentTabIndex == 0) {
                      Navigator.pushReplacement(
                        localContext,
                        MaterialPageRoute(
                            builder: (context) => Student(token: token)),
                      );
                    } else {
                      Navigator.pushReplacement(
                        localContext,
                        MaterialPageRoute(
                            builder: (context) => Faculty(token: token)),
                      );
                    }
                  });
                } else if (jsonResponse['status'] == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Wrong username or password')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Failed to connect to the server')),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
