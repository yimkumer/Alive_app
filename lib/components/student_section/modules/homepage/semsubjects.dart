import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class Subject {
  final String currentYear;
  final String currentSem;
  final String subjectCode;
  final String subjectName;
  final String subjectNameShort;

  Subject({
    required this.currentYear,
    required this.currentSem,
    required this.subjectCode,
    required this.subjectName,
    required this.subjectNameShort,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      currentYear: json['current_year'],
      currentSem: json['current_sem'],
      subjectCode: json['subject_code'],
      subjectName: json['subject_name'],
      subjectNameShort: json['subject_name_short'],
    );
  }
}

class Semsubjects extends StatefulWidget {
  final String token;

  const Semsubjects({super.key, required this.token});

  @override
  State<Semsubjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Semsubjects> {
  late Future<Map<String, List<Subject>>> dataFuture;
  String? selectedSemester;

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

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);
        Map<String, List<Subject>> subjectsBySemester = {};
        data['data'].forEach((year, semesters) {
          semesters.forEach((semester, subjectsData) {
            subjectsBySemester[semester] =
                subjectsData.map<Subject>((subjectData) {
              return Subject.fromJson(subjectData);
            }).toList();
          });
        });
        return subjectsBySemester;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 15),
            child: Row(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Semester Subjects",
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
                if (semesters.isNotEmpty && selectedSemester == null) {
                  selectedSemester = semesters.last;
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
                        value: selectedSemester,
                        hint: const Text("Select Semester"),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedSemester = newValue;
                            });
                          }
                        },
                        items: semesters
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              "Semester $value",
                              style: TextStyle(
                                color: value == selectedSemester
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
                      height: MediaQuery.of(context).size.height * 0.48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            ((snapshot.data?[selectedSemester]?.length ?? 0) +
                                    3) ~/
                                4,
                        itemBuilder: (BuildContext context, int columnIndex) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: List.generate(4, (rowIndex) {
                                final index = columnIndex * 4 + rowIndex;
                                if (index <
                                    (snapshot.data?[selectedSemester]?.length ??
                                        0)) {
                                  var subject =
                                      snapshot.data![selectedSemester]?[index];
                                  return Expanded(
                                    child: Card(
                                      elevation: 8,
                                      margin: const EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                'assets/subject.svg',
                                                height: 25,
                                                width: 25),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${subject?.subjectName}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                  Text(
                                                    '(${subject?.subjectNameShort})',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Expanded(child: SizedBox());
                                }
                              }),
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
    );
  }
}
