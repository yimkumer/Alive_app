import 'package:flutter/material.dart';

class DiagonalClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - (size.height * 0.37));
    path.lineTo(size.width, size.height - (size.height * 0.46));
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DiagonalClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - (size.height * 0.46));
    path.lineTo(size.width, size.height - (size.height * 0.37));
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Walkthrough extends StatefulWidget {
  const Walkthrough({super.key});

  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  final controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (page) {
              setState(() {
                currentPage = page;
              });
            },
            children: [
              _buildPage(
                screenSize,
                DiagonalClipper1(),
                "assets/g1.png",
                "Elevate Your\nLearning Experience",
              ),
              _buildPage(
                screenSize,
                DiagonalClipper2(),
                "assets/g2.png",
                "Explore Your\nNew Skill Today",
              ),
              _buildPage(
                screenSize,
                DiagonalClipper1(),
                "assets/g3.png",
                "Unlock Your Potential\nAnytime, Anywhere\nLearn with Ease",
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.02,
            right: screenWidth * 0.02,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                "SKIP",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.095,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPage >= index
                            ? Colors.blue
                            : const Color(0xffD9D9D9),
                      ),
                    );
                  }),
                ),
                SizedBox(height: screenHeight * 0.06),
                OutlinedButton(
                  onPressed: () {
                    if (currentPage < 2) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    } else {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    currentPage < 2 ? "NEXT" : "GET STARTED",
                    style: const TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Size screenSize, CustomClipper<Path> clipper,
      String imagePath, String text) {
    return Stack(
      children: [
        ClipPath(
          clipper: clipper,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFDCF0FF),
                  Color(0xFFBAE2FF),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: screenSize.height * 0.105,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      imagePath,
                      width: screenSize.width * 0.9,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: screenSize.height * 0.24,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
