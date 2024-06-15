import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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
  bool isGridView = true;
  List<bool> selectedItems = [];

  @override
  void initState() {
    super.initState();
  }

  void toggleViewMode() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  void selectItem(int index) {
    setState(() {
      selectedItems[index] = !selectedItems[index];
    });
  }

  void deselectAllItems() {
    setState(() {
      selectedItems = List<bool>.filled(selectedItems.length, false);
    });
  }

  void downloadSelectedItems() {
    // Add your download functionality here
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
  Future<List<Map<String, dynamic>>> fetchAttachments() async {
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
      var responseBody = await response.stream.bytesToString();
      var responseJson = jsonDecode(responseBody);
      var data = responseJson['data'];
      var attachments = data
          .map((item) {
            // Parse and format the date
            DateTime parsedDate =
                DateTime.parse(item['study_material_attachment_published_date'])
                    .toLocal();
            String formattedDate = DateFormat('dd/MM/yyyy, hh:mm a')
                .format(parsedDate); // Change the format string

            return {
              'url': item['study_material_attachment_url'],
              'title': item['study_material_attachment_title'],
              'published_date':
                  formattedDate, // Add the formatted date to the map
            };
          })
          .toList()
          .cast<Map<String, dynamic>>();
      return attachments;
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
      {'background': const Color(0xffCCE1EF), 'text': const Color(0xff1DA9FB)},
      {'background': const Color(0xffFED7FD), 'text': const Color(0xffC54098)},
    ];

    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Materials"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchStudyMaterial(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var studyMaterialName = snapshot.data?['name'];
            List<String> studyMaterialTags =
                snapshot.data?['tags'] as List<String>;
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                elevation: 8.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //HEADER SECTION
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                studyMaterialName ?? 'Default Name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //TAGS SECTION
                      Wrap(
                        alignment: WrapAlignment.start,
                        children: studyMaterialTags.map<Widget>((tag) {
                          var color = tagColors[studyMaterialTags.indexOf(tag) %
                              tagColors.length];
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: color['background'],
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: color['text'],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search attachments',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.download_outlined),
                        onPressed: () {
                          // Add your download functionality here
                        },
                      ),

                      //Dividing the sections
                      const Divider(),

                      //ATTACHMENTS SECTION
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: fetchAttachments(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: screenSize.height *
                                      0.1, // 10% of the screen height
                                ),
                                SizedBox(
                                  height: screenSize.height *
                                      0.05, // 5% of the screen height
                                  width: screenSize.width *
                                      0.1, // 10% of the screen width
                                  child: const CircularProgressIndicator(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: screenSize.height *
                                          0.02), // 2% of the screen height
                                  child: Text(
                                    "Fetching data...",
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 119, 118, 118),
                                        fontSize: screenSize.width *
                                            0.03), // 3% of the screen width
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            print('Error: ${snapshot.error}');
                            return Text('Error: ${snapshot.error}');
                          } else {
                            var attachments = snapshot.data;
                            if (selectedItems.isEmpty) {
                              selectedItems =
                                  List<bool>.filled(attachments!.length, false);
                            }
                            return SizedBox(
                              height: screenSize.height *
                                  0.7, // 70% of the screen height
                              child: Column(
                                children: <Widget>[
                                  if (selectedItems.any((selected) => selected))
                                    Row(
                                      children: <Widget>[
                                        Text(
                                            '${selectedItems.where((selected) => selected).length} Attachments selected'),
                                        IconButton(
                                          icon: const Icon(Icons.download),
                                          onPressed: downloadSelectedItems,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: deselectAllItems,
                                        ),
                                      ],
                                    ),
                                  IconButton(
                                    icon: Icon(isGridView
                                        ? Icons.view_list
                                        : Icons.view_module),
                                    onPressed: toggleViewMode,
                                  ),
                                  isGridView
                                      ? Expanded(
                                          child: buildGridView(attachments!))
                                      : Expanded(
                                          child: buildListView(attachments!)),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }

  Widget buildGridView(List<Map<String, dynamic>> attachments) {
    var screenSize = MediaQuery.of(context).size;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // number of grid columns
      ),
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        var attachment = attachments[index];
        var url = attachment['url'];
        var title = attachment['title'];
        var date = attachment[
            'published_date']; // Use 'published_date' instead of 'study_material_attachment_published_date'
        var extension = url.split('.').last;
        String assetName = 'assets/word.svg';
        switch (extension) {
          case 'pdf':
            assetName = 'assets/pdf.svg';
            break;
          case 'ppt':
          case 'pptx':
            assetName = 'assets/ppt.svg';
            break;
          case 'doc':
          case 'docx':
            assetName = 'assets/word.svg';
            break;
          default:
            assetName = 'assets/word.svg';
        }
        return GridTile(
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: selectedItems[index],
            onChanged: (bool? value) => selectItem(index),
            title: SvgPicture.asset(
              assetName,
              width: screenSize.width * 0.1,
              height: screenSize.height * 0.1,
            ),
            subtitle: Text('$title\n$date'),
          ),
        );
      },
    );
  }

  Widget buildListView(List<Map<String, dynamic>> attachments) {
    var screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        var attachment = attachments[index];
        var url = attachment['url'];
        var title = attachment['title'];
        var extension = url.split('.').last;
        String assetName = 'assets/word.svg';
        switch (extension) {
          case 'pdf':
            assetName = 'assets/pdf.svg';
            break;
          case 'ppt':
          case 'pptx':
            assetName = 'assets/ppt.svg';
            break;
          case 'doc':
          case 'docx':
            assetName = 'assets/word.svg';
            break;
          default:
            assetName = 'assets/word.svg';
        }
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: selectedItems[index],
          onChanged: (bool? value) => selectItem(index),
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  assetName,
                  width: screenSize.width * 0.1,
                  height: screenSize.height * 0.1,
                ),
                Text(title,
                    style: TextStyle(fontSize: screenSize.width * 0.03)),
              ],
            ),
          ),
        );
      },
    );
  }
}
