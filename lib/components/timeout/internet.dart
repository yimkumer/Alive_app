import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../login/login.dart';

class Internet extends StatelessWidget {
  const Internet({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/no-internet.svg',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Check your internet connection\nand try again',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(08),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.logout,
                      color: Colors.blue,
                      size: 20,
                    ),
                    TextButton(
                      child: const Text(
                        'Go to Login Page',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    });
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
