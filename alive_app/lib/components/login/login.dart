import 'package:alive_app/components/faculty_section/faculty.dart';
import 'package:alive_app/components/student_section/student.dart';
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? _buildLoadingScreen()
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
              body: _buildLoginForm(),
            ),
          );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/bg.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/alivelogo.png',
                          width: 100, height: 100),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Loading Alive...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/alivelogo.png',
                  width: 120,
                  height: 130,
                ),
                const Text('Welcome Back!', style: TextStyle(fontSize: 40)),
                const SizedBox(
                  height: 10,
                ),
                const Text('Please login to your account'),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'User name*',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 36.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF129CFF),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(02)),
                      ),
                    ),
                    onPressed: () {
                      if (_usernameController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill up the fields!')),
                        );
                      } else if (_usernameController.text != 'test' ||
                          _passwordController.text != 'password') {
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
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
