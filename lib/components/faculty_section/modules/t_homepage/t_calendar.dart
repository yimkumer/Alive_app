import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ClassInfo {
  final String selectedDate;
  final String online;
  final String startTime;
  final String endTime;
  final String interval;
  final String subjectNameShort;

  ClassInfo({
    required this.selectedDate,
    required this.online,
    required this.startTime,
    required this.endTime,
    required this.interval,
    required this.subjectNameShort,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      selectedDate: json['selected_date'],
      online: json['online'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      interval: json['interval'],
      subjectNameShort: json['subject_name_short'],
    );
  }
}

class TCalendar extends StatefulWidget {
  final String token;

  const TCalendar({super.key, required this.token});

  @override
  State<TCalendar> createState() => _TCalendarState();
}

class _TCalendarState extends State<TCalendar> {
  Map<DateTime, List<ClassInfo>> classesByDate = {};
  late DateTime startOfWeek;
  late DateTime endOfWeek;
  DateTime currentDate = DateTime.now();
  double containerWidth = 90.0;
  double containerHeight = 60.0;
  DateTime now = DateTime.now();
  late DateTime today = DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();
    startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 2));
    endOfWeek = startOfWeek.add(const Duration(days: 3));
    fetchClassesForWeek();
  }

  void fetchClassesForWeek() async {
    DateTime day = startOfWeek;
    while (day.isBefore(endOfWeek.add(const Duration(days: 1)))) {
      await fetchClasses(day);
      day = day.add(const Duration(days: 1));
    }
  }

  Future<void> fetchClasses(DateTime date) async {
    var headers = {'Authorization': 'Bearer ${widget.token}'};
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    var response = await http.get(
      Uri.parse(
          'https://api.alive.university/api/v1/classes?date=$formattedDate'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (mounted) {
        setState(() {
          classesByDate[date] = List<ClassInfo>.from(
              data['data'].map((model) => ClassInfo.fromJson(model)));
        });
      }
    } else {
      print('Failed to load classes for $formattedDate');
    }
  }

  void goToPreviousWeek() {
    setState(() {
      startOfWeek = startOfWeek.subtract(const Duration(days: 4));
      endOfWeek = startOfWeek.add(const Duration(days: 3));
      fetchClassesForWeek();
    });
  }

  void goToNextWeek() {
    setState(() {
      startOfWeek = startOfWeek.add(const Duration(days: 4));
      endOfWeek = startOfWeek.add(const Duration(days: 3));
      fetchClassesForWeek();
    });
  }

  Color getContainerColor(DateTime day, ClassInfo classInfo) {
    if (day.compareTo(today) == 0) {
      if (classInfo.online == "0") {
        return const Color(0xFFFF6714);
      } else if (classInfo.online == "1") {
        return const Color(0xFF49982E);
      }
      return const Color(0xFF8800C9);
    } else {
      return const Color(0xffF0F0F0);
    }
  }

  Color getTextColor(DateTime day) {
    if (day.compareTo(today) == 0) {
      return Colors.white;
    } else if (day.isBefore(today)) {
      return const Color(0xFF868686);
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(startOfWeek),
                  style: const TextStyle(
                    color: Color(0xFF05004E),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(Icons.circle, color: Color(0xFFFF6714), size: 5),
                const Text(
                  "Offline",
                  style: TextStyle(fontSize: 18, color: Color(0xFFFF6714)),
                ),
                const Icon(Icons.circle, color: Color(0xFF49982E), size: 5),
                const Text(
                  "Online",
                  style: TextStyle(fontSize: 18, color: Color(0xFF49982E)),
                )
              ],
            ),
          ),
          Row(
            children: List.generate(4, (index) {
              DateTime day = startOfWeek.add(Duration(days: index));
              bool isToday = day.compareTo(today) == 0;
              return Container(
                width: containerWidth,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isToday ? const Color(0xFF8800C9) : Colors.transparent,
                  border: Border.all(
                    color: const Color(0xFFDADADA),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd').format(day),
                      style: TextStyle(
                          color: isToday ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    Text(
                      DateFormat('E').format(day),
                      style: TextStyle(
                          color: isToday ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                DateTime day = startOfWeek.add(Duration(days: index));
                List<ClassInfo>? dailyClasses = classesByDate[day];
                if (dailyClasses != null) {
                  dailyClasses.sort((a, b) {
                    DateTime startTimeA =
                        DateFormat('h:mm a').parse(a.startTime);
                    DateTime startTimeB =
                        DateFormat('h:mm a').parse(b.startTime);
                    return startTimeA.compareTo(startTimeB);
                  });
                }
                return SizedBox(
                  width: containerWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListView(
                          children: dailyClasses != null
                              ? dailyClasses
                                  .map((classInfo) => Container(
                                        padding: const EdgeInsets.all(8.0),
                                        height: containerHeight + 20,
                                        decoration: BoxDecoration(
                                          color:
                                              getContainerColor(day, classInfo),
                                          border: Border.all(
                                            color: const Color(0xFFDADADA),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              classInfo.subjectNameShort,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: getTextColor(day),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                            Text(
                                              classInfo.interval,
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                color: getTextColor(day),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList()
                              : [Text(DateFormat('dd').format(day))],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: goToPreviousWeek,
                child: const Icon(
                  Icons.arrow_left,
                  size: 35,
                ),
              ),
              ElevatedButton(
                onPressed: goToNextWeek,
                child: const Icon(
                  Icons.arrow_right,
                  size: 35,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
