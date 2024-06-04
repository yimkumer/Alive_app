import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AcademicProgress extends StatelessWidget {
  const AcademicProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 243, 239, 239),
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
