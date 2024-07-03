import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isNarrow = maxWidth < 600;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 0, isNarrow ? 5 : 10),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome Yimkumer!",
                  style: TextStyle(
                    color: Color(0xFF05004E),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(isNarrow ? 10 : 20),
              padding: EdgeInsets.all(isNarrow ? 10 : 20),
              height: isNarrow ? 150 : 180,
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
              child: Row(
                children: [
                  Expanded(
                    flex: isNarrow ? 2 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.fromLTRB(0, isNarrow ? 15 : 0, 10, 0),
                          width: isNarrow ? 90 : 100,
                          height: isNarrow ? 90 : 100,
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: isNarrow ? 4 : 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Yimkumer Pongen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isNarrow ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Department : MCA',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Acharya institute of technology',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/1.png',
                          height: isNarrow ? 50 : 60,
                          width: isNarrow ? 50 : 60,
                        ),
                        Container(
                          color: Colors.black,
                          width: isNarrow ? 45 : 55,
                          child: Text(
                            'Grade',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isNarrow ? 12 : 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
