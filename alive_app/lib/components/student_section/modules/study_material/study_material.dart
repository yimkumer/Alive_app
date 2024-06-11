import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class StudyMaterial extends StatefulWidget {
  final String token;

  const StudyMaterial({super.key, required this.token});

  @override
  _StudyMaterialState createState() => _StudyMaterialState();
}

class _StudyMaterialState extends State<StudyMaterial> {
  String? dropdownValue;
  String? searchText;
  Future? dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();

    print('Token: ${widget.token}');
  }

  Future fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.postman.com/collections/21203659-7ced7ea2-1791-4f50-ae6b-4f7979a1fe7d'),
      headers: {
        'X-Api': 'PMAT-01HZ9Z4DDVFXTBBZQT37TH30CC',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        return jsonResponse['data'];
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 8,
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: const AssetImage('assets/book.jpg'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken)),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE25A26),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                style: const TextStyle(color: Colors.black),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                dropdownColor: Colors.white,
                                elevation: 8,
                                isExpanded: true,
                                itemHeight: 50,
                                iconEnabledColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              onChanged: (String value) {
                                setState(() {
                                  searchText = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search by subjects...',
                                border: InputBorder.none,
                                icon: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              //Displaying the Study materials
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: dataFuture,
                    builder: (context, snapshot) {
                      if (dropdownValue == null &&
                          (searchText == null || searchText!.isEmpty)) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30.0),
                            SvgPicture.asset(
                              'assets/smaterials.svg',
                              height: 200,
                            ),
                            const Text(
                              'Please select a institute to browse study materials or search',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF656565),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text('Data: ${snapshot.data}');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
