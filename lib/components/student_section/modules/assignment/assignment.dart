import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Assignment extends StatefulWidget {
  final String token;
  const Assignment({super.key, required this.token});

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFE6711E),
                    Color(0xFFE98815),
                    Color(0xFFEEA50B),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(25),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Assignments",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "View all your assignments here",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            // SVG Picture just below the top container
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                color: const Color(
                    0xFFFCFCFC), // Set the background color of the container
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: SvgPicture.asset("assets/noassignment.svg")),
                    const SizedBox(height: 16),
                    const Text(
                      "No Assignment Just Relax!",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
