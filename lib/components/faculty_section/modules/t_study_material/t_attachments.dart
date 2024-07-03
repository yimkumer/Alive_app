import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

class TAttachments extends StatefulWidget {
  final String studyMaterialName;
  final String studyMaterialTags;
  final String token;
  final int materialId;

  const TAttachments({
    super.key,
    required this.studyMaterialName,
    required this.studyMaterialTags,
    required this.token,
    required this.materialId,
  });

  @override
  State<TAttachments> createState() => _TAttachmentsState();
}

class _TAttachmentsState extends State<TAttachments> {
  bool isGridView = true;
  List<bool> selectedItems = [];
  Color gridViewIconColor = Colors.blue;
  Color listViewIconColor = Colors.grey;
  List<Map<String, dynamic>> attachments = [];
  late Future<Map<String, dynamic>> studyMaterialFuture;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
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
    List<Map<String, dynamic>> selectedAttachments = [];
    for (int i = 0; i < attachments.length; i++) {
      if (selectedItems[i]) {
        selectedAttachments.add(attachments[i]);
      }
    }

    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) {
      return;
    }

    List<String> allUrls = [];
    for (var attachment in selectedAttachments) {
      String url = await fetchDownloadLink(
          attachment['study_material_attachment_id'],
          attachment['study_material_attachment_url']);
      allUrls.add(url);
    }

    final studyMaterialName =
        await fetchStudyMaterial().then((data) => data['name']);

    await downloadMultipleFiles(allUrls, directoryPath, studyMaterialName);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download completed!')),
    );
    deselectAllItems();
  }

  Future<String> fetchDownloadLink(
      int attachmentId, String attachmentUrl) async {
    var headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    };
    var request = http.Request(
      'POST',
      Uri.parse(
          'https://studymaterial-api.alive.university/api/study-material/attachment/$attachmentId/download'),
    );
    request.body = json.encode({"url": attachmentUrl});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);
      return jsonData['data'];
    } else {
      print('Error: ${response.reasonPhrase}');
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
      var attachments = data.map<Map<String, dynamic>>((item) {
        DateTime parsedDate =
            DateTime.parse(item['study_material_attachment_published_date'])
                .toLocal();
        String formattedDate =
            DateFormat('dd/MM/yyyy, hh:mm a').format(parsedDate);

        return {
          'url': item['study_material_attachment_url'],
          'title': item['study_material_attachment_title'],
          'published_date': formattedDate,
          'material_id': item['study_material_attachment_id'],
          'study_material_attachment_id': item['study_material_attachment_id'],
          'study_material_attachment_url':
              item['study_material_attachment_url'],
        };
      }).toList();
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

  List<Map<String, dynamic>> get filteredAttachments {
    if (searchQuery.trim().isEmpty) {
      return attachments;
    }
    return attachments
        .where((attachment) => attachment['title']
            .toLowerCase()
            .contains(searchQuery.toLowerCase().trim()))
        .toList();
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                  elevation: 1.0,
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
                            var color = tagColors[
                                studyMaterialTags.indexOf(tag) %
                                    tagColors.length];
                            return Container(
                              margin: const EdgeInsets.all(4.0),
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: color['background'] as Color,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: color['text'] as Color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search attachments',
                              prefixIcon: const Icon(Icons.search),
                              border: const OutlineInputBorder(),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          searchQuery = '';
                                          searchController.clear();
                                        });
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(right: screenSize.width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit_note_outlined,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.restore_from_trash,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.purple,
                                  )),
                              IconButton(
                                icon: const Icon(Icons.download_outlined),
                                onPressed: () async {
                                  final directoryPath = await FilePicker
                                      .platform
                                      .getDirectoryPath();
                                  if (directoryPath == null) {
                                    return;
                                  }

                                  final studyMaterialName =
                                      await fetchStudyMaterial()
                                          .then((data) => data['name']);

                                  List<String> allUrls = [];
                                  for (var attachment in attachments) {
                                    String url = await fetchDownloadLink(
                                        attachment[
                                            'study_material_attachment_id'],
                                        attachment[
                                            'study_material_attachment_url']);
                                    allUrls.add(url);
                                  }

                                  await downloadMultipleFiles(allUrls,
                                      directoryPath, studyMaterialName);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Download completed!')),
                                  );
                                },
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  border: Border.all(
                                      color: const Color(0xFFD9D9D9)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
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
      ),
    );
  }

  Widget buildGridView() {
    var screenSize = MediaQuery.of(context).size;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      itemCount: filteredAttachments.length,
      itemBuilder: (context, index) {
        var attachment = filteredAttachments[index];
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
          case 'docx':
            assetName = 'assets/word.svg';
            break;
          default:
            assetName = 'assets/word.svg';
        }
        return GridTile(
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: selectedItems[attachments.indexOf(attachment)],
            onChanged: (bool? value) =>
                selectItem(attachments.indexOf(attachment), value),
            title: SvgPicture.asset(
              assetName,
              width: screenSize.width * 0.1,
              height: screenSize.height * 0.1,
              placeholderBuilder: (BuildContext context) => Container(),
            ),
            subtitle: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title\n',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: '$date',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildListView() {
    var screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: filteredAttachments.length,
      itemBuilder: (context, index) {
        var attachment = filteredAttachments[index];
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
          case 'docx':
            assetName = 'assets/word.svg';
            break;
          default:
            assetName = 'assets/word.svg';
        }
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: selectedItems[attachments.indexOf(attachment)],
          onChanged: (bool? value) =>
              selectItem(attachments.indexOf(attachment), value),
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  assetName,
                  width: screenSize.width * 0.1,
                  height: screenSize.height * 0.1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: screenSize.width * 0.040,
                            fontWeight: FontWeight.w500)),
                    Text(
                      date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: screenSize.width * 0.03,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
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
        borderRadius: const BorderRadius.all(Radius.circular(13)),
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
