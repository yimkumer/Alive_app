import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 5),
        child: Align(
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
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                    width: 90,
                    height: 90,
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
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 4,
              child: Column(
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
              ),
            ),
            Flexible(
              child: Column(
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
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
