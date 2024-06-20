import 'package:flutter/material.dart';

class DiagonalClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 310);
    path.lineTo(size.width, size.height - 390);
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
    path.lineTo(0.0, size.height - 390);
    path.lineTo(size.width, size.height - 310);
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
              // First Page
              Stack(
                children: [
                  ClipPath(
                    clipper: DiagonalClipper1(),
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
                            top: MediaQuery.of(context).size.height / 9.5,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Image.asset("assets/g1.png"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 200,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Elevate Your\nLearning Experience",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //Second Page
              Stack(
                children: [
                  ClipPath(
                    clipper: DiagonalClipper2(),
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
                            top: MediaQuery.of(context).size.height / 9.5,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Image.asset("assets/g2.png"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 200,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Explore Your\nNew Skill Today",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //Third Page
              Stack(
                children: [
                  ClipPath(
                    clipper: DiagonalClipper1(),
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
                            top: MediaQuery.of(context).size.height / 9.5,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Image.asset("assets/g3.png"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 200,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Unlock Your Potential\nAnytime, Anywhere\nLearn with Ease",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            right: 10,
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
            bottom: 80,
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
                const SizedBox(height: 50),
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
}
