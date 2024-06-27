import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
  Color gridViewIconColor = Colors.blue;
  Color listViewIconColor = Colors.grey;
  List<Map<String, dynamic>> attachments = [];
  late Future<Map<String, dynamic>> studyMaterialFuture;

  @override
  void initState() {
    super.initState();
    print(widget.materialId);
    studyMaterialFuture = fetchStudyMaterial();
    fetchAttachments().then((fetchedAttachments) {
      setState(() {
        attachments = fetchedAttachments;
        selectedItems = List<bool>.filled(attachments.length, false);
      });
    });
  }

  void toggleViewMode() {
    setState(() {
      isGridView = !isGridView;
      if (isGridView) {
        gridViewIconColor = Colors.blue;
        listViewIconColor = Colors.grey;
      } else {
        gridViewIconColor = Colors.grey;
        listViewIconColor = Colors.blue;
      }
    });
  }

  void selectItem(int index, bool? value) {
    setState(() {
      selectedItems[index] = value ?? false;
    });
  }

  void deselectAllItems() {
    setState(() {
      selectedItems = List<bool>.filled(selectedItems.length, false);
    });
  }

  Future<void> downloadSelectedItems() async {
    List<String> selectedUrls = [];
    for (int i = 0; i < attachments.length; i++) {
      if (selectedItems[i]) {
        selectedUrls.add(attachments[i]['url']);
      }
    }

    if (selectedUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items selected for download')),
      );
      return;
    }

    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) {
      return;
    }

    final studyMaterialName =
        await fetchStudyMaterial().then((data) => data['name']);
    await downloadMultipleFiles(selectedUrls, directoryPath, studyMaterialName);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download completed!')),
    );
  }

  Future<List<String>> fetchDownloadLink(int materialId) async {
    var headers = {
      'Authorization': 'Bearer ${widget.token}',
    };
    var request = http.Request(
      'GET',
      Uri.parse(
          'https://studymaterial-api.alive.university/api/study-material/$materialId/download'),
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);
      print('jsonData: $jsonData');
      print('jsonData[data]: ${jsonData['data']}');
      return List<String>.from(jsonData['data']);
    } else {
      throw Exception('Failed to fetch download link');
    }
  }

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
            DateTime parsedDate =
                DateTime.parse(item['study_material_attachment_published_date'])
                    .toLocal();
            String formattedDate =
                DateFormat('dd/MM/yyyy, hh:mm a').format(parsedDate);

            return {
              'url': item['study_material_attachment_url'],
              'title': item['study_material_attachment_title'],
              'published_date': formattedDate,
            };
          })
          .toList()
          .cast<Map<String, dynamic>>();
      return attachments;
    } else {
      throw Exception('Failed to load attachments');
    }
  }

  Future<File> downloadSingleFile(String url, String directoryPath) async {
    final response = await http.get(Uri.parse(url));
    var fileBytes = response.bodyBytes;
    String fileName = p.basename(Uri.parse(url).path);
    final filePath = '$directoryPath/$fileName';
    final file = File(filePath);
    try {
      await file.writeAsBytes(fileBytes);
      return file;
    } catch (e) {
      print('Could not save the file $filePath. Error: $e');
      rethrow;
    }
  }

  Future<void> downloadMultipleFiles(
      List<String> urls, String directoryPath, String studyMaterialName) async {
    final dir = Directory(directoryPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    List<File> files = [];
    for (var url in urls) {
      try {
        var file = await downloadSingleFile(url, directoryPath);
        files.add(file);
      } catch (e) {
        print('Could not download the file from $url. Error: $e');
      }
    }

    final archive = Archive();

    for (var file in files) {
      final bytes = file.readAsBytesSync();
      final fileName = p.basename(file.path);
      archive.addFile(ArchiveFile(fileName, bytes.length, bytes));

      file.deleteSync();
    }

    final zipEncoder = ZipEncoder();
    final zipFile = File('$directoryPath/$studyMaterialName.zip');
    zipFile.writeAsBytesSync(zipEncoder.encode(archive)!);
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
        future: studyMaterialFuture,
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
                      Container(
                        padding:
                            EdgeInsets.only(right: screenSize.width * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.download_outlined),
                              onPressed: () async {
                                List<String> urls =
                                    await fetchDownloadLink(widget.materialId);
                                final directoryPath = await FilePicker.platform
                                    .getDirectoryPath();
                                if (directoryPath == null) {
                                  return;
                                }

                                final dir = Directory(directoryPath);
                                if (!dir.existsSync()) {
                                  dir.createSync(recursive: true);
                                }

                                await downloadMultipleFiles(
                                    urls, directoryPath, studyMaterialName);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Download completed!'),
                                  ),
                                );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                border:
                                    Border.all(color: const Color(0xFFD9D9D9)),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.view_list,
                                        color: listViewIconColor),
                                    onPressed: () {
                                      if (!isGridView) return;
                                      toggleViewMode();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.view_module,
                                        color: gridViewIconColor),
                                    onPressed: () {
                                      if (isGridView) return;
                                      toggleViewMode();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        height: screenSize.height * 0.7,
                        child: Column(
                          children: <Widget>[
                            SelectionCountDisplay(
                              selectedItems: selectedItems,
                              onClear: deselectAllItems,
                              onDownload: downloadSelectedItems,
                            ),
                            Expanded(
                              child: isGridView
                                  ? buildGridView()
                                  : buildListView(),
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
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }

  Widget buildGridView() {
    var screenSize = MediaQuery.of(context).size;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        var attachment = attachments[index];
        var url = attachment['url'];
        var title = attachment['title'];
        var date = attachment['published_date'];
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
            onChanged: (bool? value) => selectItem(index, value),
            title: SvgPicture.asset(
              assetName,
              width: screenSize.width * 0.1,
              height: screenSize.height * 0.1,
              placeholderBuilder: (BuildContext context) => Container(),
            ),
            subtitle: Text('$title\n$date'),
          ),
        );
      },
    );
  }

  Widget buildListView() {
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
          onChanged: (bool? value) => selectItem(index, value),
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

class SelectionCountDisplay extends StatefulWidget {
  final List<bool> selectedItems;
  final VoidCallback onClear;
  final VoidCallback onDownload;

  const SelectionCountDisplay({
    super.key,
    required this.selectedItems,
    required this.onClear,
    required this.onDownload,
  });

  @override
  _SelectionCountDisplayState createState() => _SelectionCountDisplayState();
}

class _SelectionCountDisplayState extends State<SelectionCountDisplay> {
  @override
  Widget build(BuildContext context) {
    int selectedCount =
        widget.selectedItems.where((selected) => selected).length;

    if (selectedCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: const BorderRadius.all(Radius.circular(1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: widget.onClear,
          ),
          Text('$selectedCount Attachments selected'),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: widget.onDownload,
          ),
        ],
      ),
    );
  }
}
