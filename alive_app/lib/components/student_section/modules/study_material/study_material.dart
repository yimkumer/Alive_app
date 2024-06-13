import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class StudyMaterialData {
  final String studyMaterialName;
  final String studyMaterialCreatedBy;
  final String subjectCode;
  final String institute;
  final List<String> studyMaterialTags;

  StudyMaterialData({
    required this.studyMaterialName,
    required this.studyMaterialCreatedBy,
    required this.subjectCode,
    required this.institute,
    required this.studyMaterialTags,
  });

  factory StudyMaterialData.fromJson(Map<String, dynamic> json) {
    return StudyMaterialData(
      studyMaterialName: json['study_material_name'],
      studyMaterialCreatedBy: json['study_material_created_by'],
      subjectCode: json['subject_code'],
      institute: json['institute'],
      studyMaterialTags: json['study_material_tags'] is List
          ? List<String>.from(json['study_material_tags'])
          : [],
    );
  }
}

class StudyMaterial extends StatefulWidget {
  final String token;

  const StudyMaterial({super.key, required this.token});

  @override
  _StudyMaterialState createState() => _StudyMaterialState();
}

class _StudyMaterialState extends State<StudyMaterial> {
  final Map<String, String> instituteIds = {
    'Acharya Institute Of Technology': 'AIT',
    'Acharya Institute of Graduate Studies': 'AGS',
    'Acharya Polytechnic': 'APT',
    'Acharya & Bm Reddy College Of Pharmacy': 'ACP',
    'Acharyas Nrv School Of Architecture': 'ASA',
    'Smt.Nagarathnamma College Of Nursing': 'ANR',
    'Acharya School Of Design': 'ASD',
    'Acharya Institute Of Allied Health Sciences': 'AHS',
    'Smt. Nagarathnamma School Of Nursing': 'ASN',
    'Acharyas Nr institute Of Physiotherapy': 'APS',
  };

  String? dropdownValue;
  String? searchText;
  Future<List<StudyMaterialData>>? dataFuture;
  String? instituteId;
  String? fetchedInstituteId;

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData(instituteId);
  }

  Future<List<StudyMaterialData>> fetchData(String? instituteId) async {
    var headers = {'Authorization': 'Bearer ${widget.token}'};
    var queryParameters = {
      if (instituteId != null) 'institute': instituteId,
    };
    var uri = Uri.https(
      'studymaterial-api.alive.university',
      '/api/study-material',
      queryParameters,
    );
    print('URI: $uri');
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List materials = jsonResponse['data']['materials'] ?? [];
      fetchedInstituteId = instituteId;
      return materials.map((item) => StudyMaterialData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load study materials');
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
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: const AssetImage('assets/book.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.61),
                              BlendMode.darken)),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Text(
                                  'Study Materials',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Browse study materials here',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
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
                                items: instituteIds.keys
                                    .map<DropdownMenuItem<String>>(
                                        (String key) {
                                  return DropdownMenuItem<String>(
                                    value: key,
                                    child: Text(key),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    instituteId = newValue;
                                    dataFuture =
                                        fetchData(instituteIds[newValue]);
                                  });
                                },
                                hint: Text(
                                  instituteId != null
                                      ? instituteIds[instituteId] ??
                                          'Select Institute'
                                      : 'Select Institute',
                                  style: const TextStyle(
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        print('Error: ${snapshot.error}');
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Material Name',
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Created By',
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Subject-Code',
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Action',
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              snapshot.data?.length ?? 0,
                              (index) {
                                var data = snapshot.data?[index];
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                        Text(data?.studyMaterialName ?? 'N/A')),
                                    DataCell(Text(
                                        data?.studyMaterialCreatedBy ?? 'N/A')),
                                    DataCell(Text(data?.subjectCode ?? 'N/A')),
                                    const DataCell(Icon(Icons
                                        .download_rounded)), // Download icon
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        // The Future completed without data
                        return const Text('No data');
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
