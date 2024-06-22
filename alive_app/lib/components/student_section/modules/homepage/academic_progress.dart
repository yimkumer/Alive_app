import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AcademicProgress extends StatelessWidget {
  const AcademicProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Academic Progress",
                style: TextStyle(
                  color: Color(0xFF05004E),
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildCard(
                        "Overall", 0.87, const Color(0xFF50B5FF), context),
                    buildCard("Individual Year", 0.75, const Color(0xFFFFBB00),
                        context),
                    buildCard(
                        "Required", 0.65, const Color(0xFF9656FF), context),
                    buildCard(
                        "Complete", 0.95, const Color(0xFF00A916), context),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget buildCard(
      String title, double percent, Color color, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardContentWidth = screenWidth * 0.35;
    return Container(
      width: screenWidth * 0.4,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: color, width: 2.0),
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Text(
                  title,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: color, width: 2.0),
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                width: cardContentWidth,
                child: CircularPercentIndicator(
                  radius: 90.0,
                  lineWidth: 9.0,
                  percent: percent,
                  center: Text(
                    "${(percent * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  progressColor: color,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
