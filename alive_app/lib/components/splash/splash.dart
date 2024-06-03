import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/alivelogo.png',
              width: 90,
              height: 90,
            ),
          ),
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Text(
              'Alive',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
