import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/walkthrough');
    });

    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                ),
                SizedBox(width: screenWidth * 0.02), // Add a small gap
                Text(
                  "Alive",
                  style: TextStyle(
                    color: const Color(0xff05004E),
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.06,
            left: 0,
            right: 0,
            child: Text(
              'Powered by\nAcharya Group of Institutes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: const Color(0xff9F9F9F),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
