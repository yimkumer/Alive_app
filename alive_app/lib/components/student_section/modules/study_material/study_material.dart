import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

typedef DownloadLinkGetter = Future<String> Function(int materialId);

class StudyMaterialData {
  final String studyMaterialName;
  final String studyMaterialCreatedBy;
  final String subjectCode;
  final String institute;
  final int material_id;
  final List<String> studyMaterialTags;

  StudyMaterialData({
    required this.studyMaterialName,
    required this.studyMaterialCreatedBy,
    required this.subjectCode,
    required this.institute,
    required this.material_id,
    required this.studyMaterialTags,
  });

  factory StudyMaterialData.fromJson(Map<String, dynamic> json) {
    return StudyMaterialData(
      studyMaterialName: json['study_material_name'],
      studyMaterialCreatedBy: json['study_material_created_by'],
      subjectCode: json['subject_code'],
      institute: json['institute'],
      material_id: json['study_material_id'],
      studyMaterialTags: json['study_material_tags'] is List
          ? List<String>.from(json['study_material_tags'])
          : [],
    );
  }
}

class _Row {
  _Row(
    this.studyMaterialName,
    this.studyMaterialCreatedBy,
    this.subjectCode,
    this.material_id,
  );

  final String studyMaterialName;
  final String studyMaterialCreatedBy;
  final String subjectCode;
  final int material_id;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.data, this.getDownloadLink) {
    _rows = <_Row>[
      for (var item in data)
        _Row(
          item.studyMaterialName ?? 'N/A',
          item.studyMaterialCreatedBy ?? 'N/A',
          item.subjectCode ?? 'N/A',
          item.material_id ?? 0,
        ),
    ];
  }

  final BuildContext context;
  final List<dynamic> data;
  final DownloadLinkGetter getDownloadLink;
  List<_Row> _rows = [];

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) {
      return const DataRow(cells: []);
    }
    final _Row row = _rows[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(
          Row(
            children: <Widget>[
              SvgPicture.asset('assets/book_icon.svg', height: 25, width: 25),
              const SizedBox(width: 8),
              Text(row.studyMaterialName),
            ],
          ),
        ),
        DataCell(Text(row.studyMaterialCreatedBy)),
        DataCell(Text(row.subjectCode)),
        DataCell(
          const Icon(Icons.download_rounded),
          onTap: () async {
            final materialId = row.material_id;
            String url = await getDownloadLink(materialId);
            final response = await http.get(Uri.parse(url));
            final directoryPath = await FilePicker.platform.getDirectoryPath();
            if (directoryPath == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No directory selected')),
              );
              return;
            }
            final file = File('$directoryPath/file.pdf');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Download completed! File saved at ${file.path}')),
            );
            await file.writeAsBytes(response.bodyBytes);
          },
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}

class StudyMaterial extends StatefulWidget {
  final String token;

  const StudyMaterial({super.key, required this.token});

  @override
  _StudyMaterialState createState() => _StudyMaterialState();
}

class _StudyMaterialState extends State<StudyMaterial> {
  final Map<String, String> instituteIds = {
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
  String? searchText;
  Future<List<StudyMaterialData>>? dataFuture;
  String? instituteId;
  String? fetchedInstituteId;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
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

  void search(String query) {
    print('Performing search with query: $query');
    setState(() {
      searchText = query;
      if (query.isEmpty) {
        dataFuture = fetchData(dropdownValue);
      } else {
        dataFuture = fetchData(dropdownValue).then((data) {
          return data
              .where((item) =>
                  item.subjectCode.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      }
    });
  }

  //FOR getting the study materials
  Future<List<StudyMaterialData>> fetchData(String? instituteId) async {
    var headers = {'Authorization': 'Bearer ${widget.token}'};
    var queryParameters = {
      if (instituteId != null) 'institute': instituteId,
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
    } else {
      throw Exception('Failed to load study materials');
    }
  }

  //FOR getting the download link according to the study_material_id
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
        var link = responseJson['data'][0];
        return link;
      }
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
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
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
                            image: const AssetImage('assets/book.jpg'),
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
                              child: Column(
                                children: [
                                  Text(
                                    'Study Materials',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Browse study materials here',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE25A26),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  style: const TextStyle(color: Colors.black),
                                  items: instituteIds.keys
                                      .map<DropdownMenuItem<String>>(
                                          (String key) {
                                    return DropdownMenuItem<String>(
                                      value: key,
                                      child: Text(key),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      instituteId = newValue;
                                      dataFuture =
                                          fetchData(instituteIds[newValue]);
                                    });
                                  },
                                  hint: Text(
                                    instituteId != null
                                        ? instituteIds[instituteId] ??
                                            'Select Institute'
                                        : 'Select Institute',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  dropdownColor: Colors.white,
                                  elevation: 8,
                                  isExpanded: true,
                                  itemHeight: 50,
                                  iconEnabledColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                onChanged: (String value) {
                                  search(value);
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Search by subjects...',
                                  border: InputBorder.none,
                                  icon: Icon(Icons.search),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                //Displaying the Study materials
                Expanded(
                  child: FutureBuilder<List<StudyMaterialData>>(
                    future: dataFuture,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<StudyMaterialData>> snapshot) {
                      if (dataFuture == null) {
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
                        if (data.isEmpty) {
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
                                const Text(
                                  "Selected institute doesn't seem to have any study materials",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF656565),
                                    fontWeight: FontWeight.w500,
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
                                        color:
                                            Color.fromARGB(255, 116, 115, 115),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'CREATED BY',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 116, 115, 115),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'SUBJECT-CODE',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 116, 115, 115),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'ACTION',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 116, 115, 115),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              source: _DataSource(context, snapshot.data ?? [],
                                  getDownloadLink),
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
        ),
      ),
    );
  }
}
