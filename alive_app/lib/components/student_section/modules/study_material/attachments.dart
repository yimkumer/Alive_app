import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Attachments extends StatefulWidget {
  final int materialId;
  final String token;

  const Attachments({
    required Key key,
    required this.materialId,
    required this.token,
  }) : super(key: key);

  @override
  State<Attachments> createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  @override
  void initState() {
    super.initState();
    print(widget.materialId);
  }

  //TO fetch the study material name and tags
  Future<Map<String, dynamic>> fetchStudyMaterial() async {
    var headers = {
      'Authorization': 'Bearer ${widget.token}',
    };
    var request = http.Request(
      'GET',
      Uri.parse(
          'https://studymaterial-api.alive.university/api/study-material/${widget.materialId}'),
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);
      var studyMaterial = jsonData['data']['studyMaterial'];
      var studyMaterialName =
          studyMaterial['study_material_name'] ?? 'Default Name';
      List<String> studyMaterialTags = [];
      if (studyMaterial['study_material_tags'] is String) {
        studyMaterialTags = studyMaterial['study_material_tags'].split(',');
      }
      return {'name': studyMaterialName, 'tags': studyMaterialTags};
    } else {
      throw Exception(
          'Failed to load study material: ${response.reasonPhrase}');
    }
  }

  //TO fetch the study material attachments
  Future<String> fetchAttachments() async {
    var headers = {
      'Authorization': 'Bearer ${widget.token}',
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://studymaterial-api.alive.university/api/study-material/${widget.materialId}/attachments'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw Exception('Failed to load attachments');
    }
  }

  @override
  Widget build(BuildContext context) {
    var tagColors = [
      {'background': const Color(0xffDAFFD4), 'text': const Color(0xff1FC439)},
      {'background': const Color(0xffFFD9CB), 'text': const Color(0xffE25A28)},
      {'background': const Color(0xffFFEBFF), 'text': const Color(0xff5E2974)},
      {'background': const Color(0xffFFDAFE), 'text': const Color(0xffAC00E5)},
      {'background': const Color(0xffFFE3E2), 'text': const Color(0xffFF5486)},
    ];

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchStudyMaterial(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}'); // Print the error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var studyMaterialName = snapshot.data?['name'];
            List<String> studyMaterialTags =
                snapshot.data?['tags'] as List<String>;
            print('Study Material Tags: $studyMaterialTags');
            return Card(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const BackButton(),
                      Text(studyMaterialName ?? 'Default Name'),
                    ],
                  ),
                  Wrap(
                    children: studyMaterialTags.map<Widget>((tag) {
                      var color = tagColors[
                          studyMaterialTags.indexOf(tag) % tagColors.length];
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: color['background'],
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(color: color['text']),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
