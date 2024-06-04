import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      heightFactor: 3,
      child: Text(
        "Welcome to Digital Classroom!",
        style: TextStyle(
          color: Color(0xFF131A40),
          fontWeight: FontWeight.w500,
          fontSize: 15.0,
        ),
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 15, 10, 0),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: Text(
          'Y',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Yimkumer Pongen',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        Text(
          'Department : MCA',
          style: TextStyle(color: Colors.white),
        ),
        Text(
          'Acharya institute of technology',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class GradeContainer extends StatelessWidget {
  const GradeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/1.png',
          height: 50,
          width: 50,
        ),
        Container(
          color: Colors.black,
          width: 45,
          child: const Text(
            'Grade',
            style: TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class AcademicProgress extends StatelessWidget {
  const AcademicProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Academic Progress',
                style: TextStyle(color: Color(0xFF05004E), fontSize: 20),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      buildButton('Overall'),
                      buildButton('Year'),
                      buildButton('Required'),
                      buildButton('Completed'),
                    ],
                  ),
                ),
                const Spacer(),
                CircularPercentIndicator(
                  radius: 150.0,
                  lineWidth: 10.0,
                  percent: 0.87,
                  center: const Text(
                    "87%",
                    style: TextStyle(color: Color(0xFF242064), fontSize: 25),
                  ),
                  progressColor: const Color(0xFF139CFF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return const Color(0xFF139CFF);
              }
              return Colors.white;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) return Colors.white;
              return Colors.black;
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

class std_home extends StatelessWidget {
  const std_home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WelcomeText(),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFD5DF3A),
                    Color(0xFF3EB921),
                    Color(0xFF00A917),
                  ],
                ),
              ),
              child: const Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      ProfileContainer(),
                    ],
                  ),
                  ProfileInfo(),
                  Spacer(),
                  GradeContainer(),
                ],
              ),
            ),
            const AcademicProgress(),
          ],
        ),
      ),
    );
  }
}
