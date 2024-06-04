import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscureText;
  final Function(String, String) onLogin;
  final Function onTogglePasswordVisibility;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.obscureText,
    required this.onLogin,
    required this.onTogglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                  controller: usernameController,
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
                  controller: passwordController,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => onTogglePasswordVisibility(),
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
                      onLogin(usernameController.text, passwordController.text);
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
