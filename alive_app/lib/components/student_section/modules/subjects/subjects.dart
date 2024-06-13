import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Subject {
  final String currentYear;
  final String currentSem;
  final String subjectId;
  final String subjectCode;
  final String subjectName;
  final String subjectNameShort;

  Subject({
    required this.currentYear,
    required this.currentSem,
    required this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.subjectNameShort,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      currentYear: json['current_year'],
      currentSem: json['current_sem'],
      subjectId: json['subject_id'],
      subjectCode: json['subject_code'],
      subjectName: json['subject_name'],
      subjectNameShort: json['subject_name_short'],
    );
  }
}

class Subjects extends StatefulWidget {
  final String token;
  const Subjects({super.key, required this.token});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  String? dropdownValue;
  String? searchText;
  late Future<List<Subject>> dataFuture;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData().then((subjects) {
      var semesters = subjects
          .map((subject) => 'Semester ${subject.currentSem}')
          .toSet()
          .toList();
      semesters.sort();
      setState(() {
        dropdownValue = semesters.last;
      });
      return subjects;
    });
  }

  Future<List<Subject>> fetchData() async {
    var headers = {'Authorization': 'Bearer ${widget.token}'};
    var request = http.Request(
        'GET', Uri.parse('https://api.alive.university/api/v1/user-subjects'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);

      List<Subject> subjects = [];
      data['data'].forEach((year, semesters) {
        semesters.forEach((semester, subjectsData) {
          for (var subjectData in subjectsData) {
            subjects.add(Subject.fromJson(subjectData));
          }
        });
      });

      return subjects;
    } else {
      print('Status code: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            color: const Color(0xFFFDF9F0),
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
                            image: const AssetImage('assets/subjects.jpg'),
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
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your Subjects',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Manage your subjects',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Search subjects...',
                                  border: InputBorder.none,
                                  icon: Icon(Icons.search),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE25A26),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: FutureBuilder<List<Subject>>(
                                future: dataFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      'Semester...',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    var semesters = snapshot.data!
                                        .map((subject) =>
                                            'Semester ${subject.currentSem}')
                                        .toSet()
                                        .toList();
                                    semesters.sort();
                                    dropdownValue =
                                        dropdownValue ?? semesters.last;
                                    return SizedBox(
                                      height: 50.0,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: dropdownValue,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                          items: semesters
                                              .map<DropdownMenuItem<String>>(
                                                  (value) {
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
                                          dropdownColor:
                                              const Color(0xFFE25A26),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          iconEnabledColor: Colors.white,
                                          elevation: 8,
                                          isExpanded: true,
                                          itemHeight: 50,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                //Displaying the Subjects
                Expanded(
                  child: FutureBuilder<List<Subject>>(
                    future: dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}\nStack trace: ${snapshot.stackTrace}');
                      } else {
                        var subjects = snapshot.data!
                            .where((subject) =>
                                subject.currentSem ==
                                dropdownValue?.split(' ')[1])
                            .toList();

                        return ValueListenableBuilder(
                          valueListenable: _searchController,
                          builder: (context, value, child) {
                            final searchText =
                                _searchController.text.toLowerCase();
                            final filteredSubjects = subjects.where((subject) {
                              final subjectName =
                                  subject.subjectName.toLowerCase();
                              final subjectCode =
                                  subject.subjectCode.toLowerCase();
                              return subjectName.contains(searchText) ||
                                  subjectCode.contains(searchText);
                            }).toList();

                            return filteredSubjects.isEmpty
                                ? Center(
                                    child: Text(
                                        'No subject matches the search text: $searchText'))
                                : ListView.builder(
                                    itemCount: filteredSubjects.length,
                                    itemBuilder: (context, index) {
                                      final subject = filteredSubjects[index];
                                      return Container(
                                        margin: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ListTile(
                                          leading: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.17,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: const Color(0xFFFF7039),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                subject.subjectNameShort
                                                    .substring(
                                                        0,
                                                        min(
                                                            3,
                                                            subject
                                                                .subjectNameShort
                                                                .length)),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            '${subject.subjectName} (${subject.subjectCode})',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          subtitle: Text(
                                            subject.subjectNameShort,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 97, 96, 96)),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
