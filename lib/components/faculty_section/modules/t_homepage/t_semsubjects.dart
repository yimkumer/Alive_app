import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class Subject {
  final String acYear;
  final String subjectName;
  final String subjectCode;
  final String subjectNameShort;

  Subject({
    required this.acYear,
    required this.subjectName,
    required this.subjectCode,
    required this.subjectNameShort,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      acYear: json['ac_year'],
      subjectName: json['subject_name'],
      subjectCode: json['subject_code'],
      subjectNameShort: json['subject_name_short'],
    );
  }
}

class TSemsubjects extends StatefulWidget {
  final String token;

  const TSemsubjects({super.key, required this.token});

  @override
  State<TSemsubjects> createState() => _TSemsubjectsState();
}

class _TSemsubjectsState extends State<TSemsubjects> {
  late Future<Map<String, List<Subject>>> dataFuture;
  String? selectedYear;

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  Future<Map<String, List<Subject>>> fetchData() async {
    var headers = {'Authorization': 'Bearer ${widget.token}'};
    var request = http.Request(
        'GET', Uri.parse('https://api.alive.university/api/v1/user-subjects'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);
      Map<String, Subject> latestSubjects = {};
      for (var item in data['data']) {
        Subject subject = Subject.fromJson(item);
        if (!latestSubjects.containsKey(subject.subjectCode) ||
            latestSubjects[subject.subjectCode]!
                    .acYear
                    .compareTo(subject.acYear) <
                0) {
          latestSubjects[subject.subjectCode] = subject;
        }
      }
      Map<String, List<Subject>> categorizedSubjects = {};
      for (var subject in latestSubjects.values) {
        categorizedSubjects.putIfAbsent(subject.acYear, () => []).add(subject);
      }
      var sortedKeys = categorizedSubjects.keys.toList()
        ..sort((a, b) {
          var endYearA = int.parse(a.split('-')[1]);
          var endYearB = int.parse(b.split('-')[1]);
          return endYearA.compareTo(endYearB);
        });
      Map<String, List<Subject>> sortedCategorizedSubjects = {};
      for (var key in sortedKeys) {
        sortedCategorizedSubjects[key] = categorizedSubjects[key]!;
      }
      return sortedCategorizedSubjects;
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 15),
              child: Row(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Year Subjects",
                      style: TextStyle(
                        color: Color(0xFF05004E),
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset("assets/sembooks.png"),
                ],
              ),
            ),
            FutureBuilder<Map<String, List<Subject>>>(
              future: dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Text('No subjects available');
                } else {
                  List<String> semesters = snapshot.data!.keys.toList();
                  if (semesters.isNotEmpty && selectedYear == null) {
                    selectedYear = semesters.last;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                              color: const Color(0xffF18833), width: 1),
                        ),
                        child: DropdownButton<String>(
                          value: selectedYear,
                          hint: const Text("Select Year"),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedYear = newValue!;
                            });
                          },
                          items: semesters
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                "Year $value",
                                style: TextStyle(
                                  color: value == selectedYear
                                      ? const Color(0xffF18833)
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                          isDense: true,
                          iconSize: 24,
                          underline: Container(),
                          dropdownColor: Colors.white,
                          iconEnabledColor: const Color(0xffF18833),
                        ),
                      ),
                      const SizedBox(
                        height: 05,
                      ),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: snapshot.data?[selectedYear]?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            var subject = snapshot.data![selectedYear]?[index];
                            return Card(
                              elevation: 8,
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: SvgPicture.asset('assets/subject.svg',
                                    height: 25, width: 25),
                                title: Text(
                                    ' ${subject?.subjectName} (${subject?.subjectNameShort})'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
