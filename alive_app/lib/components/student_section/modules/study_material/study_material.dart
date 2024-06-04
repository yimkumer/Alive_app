import 'package:flutter/material.dart';

class StudyMaterial extends StatefulWidget {
  const StudyMaterial({super.key});

  @override
  _StudyMaterialState createState() => _StudyMaterialState();
}

class _StudyMaterialState extends State<StudyMaterial> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Study Materials',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Browse study materials here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButton<String>(
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    items: <String>[
                      'Acharya Institute Of Technology',
                      'Acharya Institute of Graduate Studies',
                      'Acharya Polytechnic',
                      'Acharya & Bm Reddy College Of Pharmacy',
                      'Acharyas Nrv School Of Architecture',
                      'Smt.Nagarathnamma College Of Nursing',
                      'Acharya School Of Design',
                      'Acharya Institute Of Allied Health Sciences',
                      'Smt. Nagarathnamma School Of Nursing',
                      'Acharyas Nr institute Of Physiotherapy',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    hint: const Text(
                      'Select Institute',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
