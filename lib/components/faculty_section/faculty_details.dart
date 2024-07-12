import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../timeout/timeout.dart';

class faculty_details {
  final String token;
  final BuildContext context;

  faculty_details({required this.token, required this.context});

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
          'employee_name': sessionData['employee_name'] ?? '',
          'branch_name': sessionData['branch_name'] ?? '',
          'empcode': sessionData['empcode'] ?? '',
          'lms_role': sessionData['lms_role'] ?? '',
        };
      } else if (response.statusCode == 401) {
        // Token has expired, handle accordingly
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
