import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
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

class TSubjects extends StatefulWidget {
  final String token;

  const TSubjects({super.key, required this.token});

  @override
  State<TSubjects> createState() => _TSubjectsState();
}

class _TSubjectsState extends State<TSubjects> {
  String? dropdownValue;
  String? searchText;
  late Future<List<Subject>> dataFuture;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData().then((subjects) {
      var semesters =
          subjects.map((subject) => subject.acYear).toSet().toList();
      semesters.sort((a, b) => a.compareTo(b));
      setState(() {
        dropdownValue = semesters.isNotEmpty ? semesters.last : null;
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
      return latestSubjects.values.toList();
    } else {
      throw Exception('Failed to load subjects');
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
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.24,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: const AssetImage('assets/subjects.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.61), BlendMode.darken)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  'Manage all your subjects here',
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width * 0.9,
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
                            onChanged: (text) {
                              setState(() {
                                searchText = text;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE25A26),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: FutureBuilder<List<Subject>>(
                            future: dataFuture,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                  'Academic Year...',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                var semesters = snapshot.data!
                                    .map((subject) => subject.acYear)
                                    .toSet()
                                    .toList();
                                semesters.sort();

                                dropdownValue = dropdownValue ?? semesters.last;
                                return SizedBox(
                                  height: 50.0,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      items: semesters
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text("Academic year $value"),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },
                                      dropdownColor: const Color(0xFFE25A26),
                                      borderRadius: BorderRadius.circular(12.0),
                                      iconEnabledColor: Colors.white,
                                      elevation: 1,
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

            // Displaying the Subjects
            Expanded(
              child: FutureBuilder<List<Subject>>(
                future: dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('Loading...'));
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}\nStack trace: ${snapshot.stackTrace}');
                  } else {
                    var subjects = snapshot.data!
                        .where((subject) => subject.acYear == dropdownValue)
                        .toList();
                    final searchText = _searchController.text.toLowerCase();
                    final filteredSubjects = subjects.where((subject) {
                      final subjectName = subject.subjectName.toLowerCase();
                      final subjectCode = subject.subjectCode.toLowerCase();
                      return subjectName.contains(searchText) ||
                          subjectCode.contains(searchText);
                    }).toList();
                    return filteredSubjects.isEmpty
                        ? Center(
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  const TextSpan(
                                      text:
                                          'No subject matches the search text: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: searchText,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredSubjects.length,
                            itemBuilder: (context, index) {
                              final subject = filteredSubjects[index];
                              return Container(
                                margin: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.17,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xFFFF7039)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        subject.subjectNameShort.substring(
                                            0,
                                            min(
                                                3,
                                                subject
                                                    .subjectNameShort.length)),
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                      '${subject.subjectName} (${subject.subjectCode})',
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  subtitle: Text(subject.subjectNameShort,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 97, 96, 96))),
                                ),
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
    );
  }
}
