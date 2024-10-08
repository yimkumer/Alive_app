import 'dart:convert';
import 'dart:io';
import 'package:alive_app/components/student_section/modules/study_material/attachments.dart';
import 'package:alive_app/components/timeout/timeout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

typedef DownloadLinkGetter = Future<String> Function(int materialId);

class StudyMaterialData {
  final String studyMaterialName;
  final String studyMaterialCreatedBy;
  final String subjectCode;
  final String subjectname;
  final String institute;
  final int material_id;

  StudyMaterialData({
    required this.studyMaterialName,
    required this.studyMaterialCreatedBy,
    required this.subjectCode,
    required this.subjectname,
    required this.institute,
    required this.material_id,
  });

  factory StudyMaterialData.fromJson(Map<String, dynamic> json) {
    return StudyMaterialData(
      studyMaterialName: json['study_material_name'],
      studyMaterialCreatedBy: json['study_material_created_by'],
      subjectCode: json['subject_code'],
      subjectname: json['subject_name'],
      institute: json['institute'],
      material_id: json['study_material_id'],
    );
  }
}

class StudyMaterial extends StatefulWidget {
  final String token;

  const StudyMaterial({super.key, required this.token});

  @override
  _StudyMaterialState createState() => _StudyMaterialState();
}

class _StudyMaterialState extends State<StudyMaterial> {
  Map<String, String> instituteIds = {
    'Acharya Institute Of Technology': 'AIT',
    'Acharya Institute of Graduate Studies': 'AGS',
    'Acharya Polytechnic': 'APT',
    'Acharya & Bm Reddy College Of Pharmacy': 'ACP',
    'Acharyas Nrv School Of Architecture': 'ASA',
    'Smt.Nagarathnamma College Of Nursing': 'ANR',
    'Acharya School Of Design': 'ASD',
    'Acharya Institute Of Allied Health Sciences': 'AHS',
    'Smt. Nagarathnamma School Of Nursing': 'ASN',
    'Acharyas Nr institute Of Physiotherapy': 'APS',
  };

  String? dropdownValue;
  Future<List<StudyMaterialData>>? dataFuture;
  String? instituteId;
  String? fetchedInstituteId;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final searchTextController = TextEditingController();
  String searchQuery = '';
  List<StudyMaterialData> allMaterials = [];

  @override
  void initState() {
    super.initState();
    preloadData();
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    var headers = {'Authorization': 'Bearer ${widget.token}'};
    var request = http.Request(
        'GET', Uri.parse('https://api.alive.university/api/v1/organization'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var responseJson = jsonDecode(responseBody);
      setState(() {
        instituteIds = {
          for (var item in responseJson['data'])
            item['institute_name']: item['institute_name_short']
        };
      });
    } else if (response.statusCode == 401) {
      // Token has expired, handle accordingly
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Timeout()),
        (Route<dynamic> route) => false,
      );
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> preloadData() async {
    var headers = {
      'Authorization': 'Bearer ${widget.token}',
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://studymaterial-api.alive.university/api/study-material'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      List materials = jsonResponse['data']['materials'] ?? [];
      if (mounted) {
        setState(() {
          allMaterials = materials
              .map((item) => StudyMaterialData.fromJson(item))
              .toList();
        });
      }
    } else if (response.statusCode == 401) {
      // Token has expired, handle accordingly
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Timeout()),
        (Route<dynamic> route) => false,
      );
    } else {
      print(response.reasonPhrase);
    }
  }

  void onQueryParameterSelected(String selectedInstituteId) {
    setState(() {
      instituteId = selectedInstituteId;
      dataFuture = fetchData(instituteId);
    });
  }

  void onDropdownValueChanged(String newValue) {
    setState(() {
      dropdownValue = newValue;
      dataFuture = fetchData(dropdownValue);
    });
  }

  List<StudyMaterialData> filterStudyMaterials(
      List<StudyMaterialData> materials) {
    if (searchQuery.isEmpty) {
      return materials;
    }
    return materials.where((material) {
      return material.studyMaterialName
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          material.subjectCode
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
    }).toList();
  }

  Future<List<StudyMaterialData>> fetchData(String? instituteId) async {
    if (instituteId == null) {
      return allMaterials;
    }
    var headers = {'Authorization': 'Bearer ${widget.token}'};
    var queryParameters = {
      'institute': instituteId,
    };
    var uri = Uri.https(
      'studymaterial-api.alive.university',
      '/api/study-material',
      queryParameters,
    );
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List materials = jsonResponse['data']['materials'] ?? [];
      fetchedInstituteId = instituteId;
      return materials.map((item) => StudyMaterialData.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      // Token has expired, handle accordingly
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Timeout()),
        (Route<dynamic> route) => false,
      );
      return [];
    } else {
      throw Exception('Failed to load study materials');
    }
  }

  Future<String> getDownloadLink(int materialId) async {
    var headers = {'Authorization': 'Bearer ${widget.token}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://studymaterial-api.alive.university/api/study-material/$materialId/download'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var responseJson = jsonDecode(responseBody);
      if (responseJson['success'] == true) {
        var links = responseJson['data'].cast<String>();
        return links.join(', ');
      }
    } else if (response.statusCode == 401) {
      // Token has expired, handle accordingly
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Timeout()),
        (Route<dynamic> route) => false,
      );
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.24,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: const AssetImage('assets/book.jpg'),
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
                          child: Column(
                            children: [
                              Text(
                                'View all study materials here',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: searchTextController,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                                if (value.isNotEmpty) {
                                  dataFuture = Future.value(
                                      filterStudyMaterials(allMaterials));
                                } else {
                                  dataFuture = null;
                                }
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search by subject name or code...',
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE25A26),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: instituteId,
                              style: const TextStyle(color: Colors.white),
                              items: instituteIds.entries
                                  .map<DropdownMenuItem<String>>((entry) {
                                return DropdownMenuItem<String>(
                                  value: entry.value,
                                  child: Text(entry.key),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  instituteId = newValue;
                                  dataFuture = fetchData(instituteId);
                                });
                              },
                              hint: Text(
                                instituteId != null
                                    ? instituteIds.entries
                                        .firstWhere((entry) =>
                                            entry.value == instituteId)
                                        .key
                                    : 'Select Institute',
                                style: const TextStyle(color: Colors.white),
                              ),
                              dropdownColor: const Color(0xFFE25A26),
                              borderRadius: BorderRadius.circular(12.0),
                              elevation: 1,
                              isExpanded: true,
                              itemHeight: 50,
                              iconEnabledColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<StudyMaterialData>>(
                future: dataFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<StudyMaterialData>> snapshot) {
                  if (dataFuture == null && searchQuery.isEmpty) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30.0),
                          SvgPicture.asset(
                            'assets/smaterials.svg',
                            height: 200,
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            'Please select an institute to browse study materials or search',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF656565),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: CircularProgressIndicator(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              "Fetching data...",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 119, 118, 118),
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<StudyMaterialData> data =
                        snapshot.data as List<StudyMaterialData>;
                    List<StudyMaterialData> filteredData =
                        filterStudyMaterials(data);
                    if (filteredData.isEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30.0),
                            SvgPicture.asset(
                              'assets/no_material.svg',
                              height: 200,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              searchQuery.isEmpty
                                  ? "Selected institute doesn't seem to have any study materials"
                                  : "No matching study materials found",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF656565),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.purple),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  dataFuture = null;
                                  searchTextController.clear();
                                  searchQuery = '';
                                  instituteId = null;
                                });
                              },
                              child: const Text(
                                'Remove Filter',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: PaginatedDataTable(
                          headingRowColor: WidgetStateColor.resolveWith(
                              (states) =>
                                  const Color.fromARGB(255, 236, 236, 236)),
                          rowsPerPage: _rowsPerPage,
                          availableRowsPerPage: const <int>[10, 25, 50],
                          onRowsPerPageChanged: (int? value) {
                            setState(() {
                              _rowsPerPage = value ?? _rowsPerPage;
                            });
                          },
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'MATERIAL NAME',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 116, 115, 115),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'CREATED BY',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 116, 115, 115),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'SUBJECT-CODE',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 116, 115, 115),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ACTION',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 116, 115, 115),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          source: _DataSource(context, filteredData,
                              getDownloadLink, widget.token),
                        ),
                      );
                    }
                  } else {
                    return const Text('No data');
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

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.data, this.getDownloadLink, this.token);

  final BuildContext context;
  final List<StudyMaterialData> data;
  final DownloadLinkGetter getDownloadLink;
  final String token;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= data.length) return const DataRow(cells: [DataCell(Text(''))]);
    final row = data[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Attachments(
                      key: ValueKey(row.material_id),
                      materialId: row.material_id,
                      token: token),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset('assets/book_icon.svg', height: 25, width: 25),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(row.studyMaterialName,
                        style: const TextStyle(
                            color: Color(0XFF464E5B),
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
        DataCell(GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Attachments(
                      key: ValueKey(row.material_id),
                      materialId: row.material_id,
                      token: token),
                ),
              );
            },
            child: Text(row.studyMaterialCreatedBy,
                style: const TextStyle(
                    color: Color(0XFF464E5B), fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip))),
        DataCell(GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Attachments(
                      key: ValueKey(row.material_id),
                      materialId: row.material_id,
                      token: token),
                ),
              );
            },
            child: Text('${row.subjectname}-${row.subjectCode}',
                style: const TextStyle(
                    color: Color(0XFF464E5B), fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis))),
        DataCell(
          const Icon(Icons.download_rounded),
          onTap: () async {
            String url = await getDownloadLink(row.material_id);
            List<String> urls = url.split(', ');
            final directoryPath = await FilePicker.platform.getDirectoryPath();
            if (directoryPath == null) {
              return;
            }
            await downloadMultipleFiles(
                urls, directoryPath, row.studyMaterialName);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Download completed!'),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

Future<void> downloadMultipleFiles(
    List<String> urls, String directoryPath, String studyMaterialName) async {
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
