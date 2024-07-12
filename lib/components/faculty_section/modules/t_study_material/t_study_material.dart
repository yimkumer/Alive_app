import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import '../../../timeout/timeout.dart';
import 't_attachments.dart';
import 't_create_material.dart';

class TStudyMaterial extends StatefulWidget {
  final String token;

  const TStudyMaterial({super.key, required this.token});

  @override
  State<TStudyMaterial> createState() => _TStudyMaterialState();
}

class _TStudyMaterialState extends State<TStudyMaterial> {
  List<StudyMaterialData> allMaterials = [];
  List<StudyMaterialData> filteredMaterials = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var headers = {'Authorization': 'Bearer ${widget.token}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://studymaterial-api.alive.university/api/study-material'));
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        List materials = jsonResponse['data']['materials'];
        List docsCounts = jsonResponse['data']['docsCount'];
        setState(() {
          allMaterials = materials.map((item) {
            var docsCount = docsCounts.firstWhere(
              (doc) => doc['study_material_id'] == item['study_material_id'],
              orElse: () => {'docs_count': '0'},
            )['docs_count'];
            return StudyMaterialData.fromJson(item, docsCount);
          }).toList();
          filteredMaterials = List.from(allMaterials);
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        // Token has expired, handle accordingly
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Timeout()),
          (Route<dynamic> route) => false,
        );
      } else {
        print(response.reasonPhrase);
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  void filterMaterials(String query) {
    setState(() {
      filteredMaterials = allMaterials
          .where((material) =>
              material.studyMaterialName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              material.subjectCode.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
          children: [
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
                padding: const EdgeInsets.fromLTRB(18, 15, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Manage your study materials here',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
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
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search by subjects',
                          icon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                        onChanged: filterMaterials,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE25A26),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TCreateMaterial(token: widget.token),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                          Text(
                            " Create",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredMaterials.isEmpty
                      ? const Center(child: Text('No materials found'))
                      : SingleChildScrollView(
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
                                  'SUBJECT-CODE',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 116, 115, 115),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'CREATED ON',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 116, 115, 115),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'DOCUMENT COUNT',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 116, 115, 115),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            source: _DataSource(
                                context, filteredMaterials, widget.token),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.data, this.token);
  final BuildContext context;
  final List<StudyMaterialData> data;
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
                  builder: (context) => TAttachments(
                    studyMaterialName: row.studyMaterialName,
                    studyMaterialTags: row.studyMaterialTags,
                    token: token,
                    materialId: row.studyMaterialId,
                  ),
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
        DataCell(Text('${row.subjectName}-${row.subjectCode}',
            style: const TextStyle(
                color: Color(0XFF464E5B), fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip)),
        DataCell(Text(
          row.formattedDate,
          style: const TextStyle(
              color: Color(0XFF464E5B), fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          row.docsCount,
          style: const TextStyle(
              color: Color(0XFF464E5B), fontWeight: FontWeight.bold),
        )),
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

class StudyMaterialData {
  final int studyMaterialId;
  final String studyMaterialName;
  final String studyMaterialTags;
  final String subjectCode;
  final String subjectName;
  final String studyMaterialPublishedDate;
  final String docsCount;

  StudyMaterialData({
    required this.studyMaterialId,
    required this.studyMaterialName,
    required this.studyMaterialTags,
    required this.subjectCode,
    required this.subjectName,
    required this.studyMaterialPublishedDate,
    required this.docsCount,
  });

  factory StudyMaterialData.fromJson(
      Map<String, dynamic> json, String docsCount) {
    return StudyMaterialData(
      studyMaterialId: json['study_material_id'],
      studyMaterialName: json['study_material_name'],
      studyMaterialTags: json['study_material_tags'],
      subjectCode: json['subject_code'],
      subjectName: json['subject_name'],
      studyMaterialPublishedDate: json['study_material_published_date'],
      docsCount: docsCount,
    );
  }

  String get formattedDate {
    DateTime parsedDate = DateTime.parse(studyMaterialPublishedDate);
    return '${parsedDate.day.toString().padLeft(2, '0')}-'
        '${parsedDate.month.toString().padLeft(2, '0')}-'
        '${parsedDate.year}';
  }
}
