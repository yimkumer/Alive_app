import 'package:alive_app/components/timeout/timeout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class student_details {
  final String token;
  final BuildContext context;

  student_details({required this.token, required this.context});

  Future<Map<String, dynamic>> fetchUserData() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET', Uri.parse('https://api.alive.university/api/v1/user'));
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> data = json.decode(responseBody);
        var sessionData = data['data']['session_data'];
        return {
          'student_name': sessionData['student_name'] ?? '',
          'course_branch_short_name':
              sessionData['course_branch_short_name'] ?? '',
          'institute_name_short': sessionData['institute_name_short'] ?? '',
          'user_id': sessionData['user_id'] ?? '',
          'user_role': sessionData['user_role'] ?? '',
        };
      } else if (response.statusCode == 401) {
        // Token has expired
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Timeout()),
          (Route<dynamic> route) => false,
        );
        return {};
      } else {
        print('Error: ${response.reasonPhrase}');
        return {};
      }
    } catch (e) {
      print('Exception occurred: $e');
      return {};
    }
  }
}
