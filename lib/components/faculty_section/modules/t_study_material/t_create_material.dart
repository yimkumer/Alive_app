import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TCreateMaterial extends StatefulWidget {
  final String token;

  const TCreateMaterial({super.key, required this.token});

  @override
  State<TCreateMaterial> createState() => _TCreateMaterialState();
}

class _TCreateMaterialState extends State<TCreateMaterial> {
  List<dynamic> subjects = [];
  String? selectedSubject;
  String latestAcYear = '';
  final TextEditingController _materialNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  @override
  void dispose() {
    _materialNameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  fetchSubjects() async {
    var headers = {
      'Authorization': 'Bearer ${widget.token}',
    };
    var request = http.Request(
        'GET', Uri.parse('https://api.alive.university/api/v1/user-subjects'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      var jsonData = json.decode(data);
      setState(() {
        subjects = jsonData['data'];
        if (subjects.isNotEmpty) {
          // Sort subjects by ac_year in descending order
          subjects.sort((a, b) => b['ac_year'].compareTo(a['ac_year']));
          // Get the latest ac_year
          latestAcYear = subjects.first['ac_year'];
          // Filter subjects to only include those from the latest ac_year
          subjects = subjects
              .where((subject) => subject['ac_year'] == latestAcYear)
              .toList();
          // Remove duplicates based on subject name, code, and academic year
          subjects = subjects.fold<List<dynamic>>([], (uniqueList, subject) {
            if (!uniqueList.any((s) =>
                s['subject_name'] == subject['subject_name'] &&
                s['subject_code'] == subject['subject_code'] &&
                s['ac_year'] == subject['ac_year'])) {
              uniqueList.add(subject);
            }
            return uniqueList;
          });
        }
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        _buildHeader(constraints),
                        Expanded(child: _buildForm(constraints)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight * 0.18,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF312F42),
            Color(0xFF3D3B53),
            Color(0xFF4A4864),
          ],
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add new material',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Provide all the required information to create a material',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField("Material name *", _materialNameController,
              'Eg: New material for DS'),
          const SizedBox(height: 20),
          _buildInputField("Description *", _descriptionController,
              'Description goes here...',
              maxLines: 5),
          const SizedBox(height: 20),
          _buildDropdown(constraints),
          const SizedBox(height: 20),
          _buildInputField("Add Tags (Type tags as comma separated values)",
              _tagsController, 'Add new tag'),
          const SizedBox(height: 20),
          _buildUploadSection(constraints),
          const SizedBox(height: 20),
          _buildButtons(constraints),
        ],
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            color: Color(0xFF7B7E8B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF7B7E8B)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF59B9FE)),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Material Subject *",
          style: TextStyle(
            fontSize: 17,
            color: Color(0xFF7B7E8B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF7B7E8B)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Select Subject"),
              value: selectedSubject,
              items: subjects.map<DropdownMenuItem<String>>((subject) {
                String displayText =
                    "${subject['subject_name']} - ${subject['subject_code']} (${subject['ac_year']})";
                return DropdownMenuItem<String>(
                  value: displayText,
                  child: Text(displayText),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Showing subjects for academic year: $latestAcYear",
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF7B7E8B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection(BoxConstraints constraints) {
    return CustomPaint(
      painter: DashedRect(
        color: const Color(0xFF83CBFF),
        strokeWidth: 2,
        gap: 5,
      ),
      child: GestureDetector(
        onTap: () {
          // Add your file upload logic here
        },
        child: Container(
          width: constraints.maxWidth,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0XFFF3FAFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                Icons.upload_file_outlined,
                size: constraints.maxWidth * 0.2,
                color: const Color(0xFF5FBBFF),
              ),
              const SizedBox(height: 16),
              const Text(
                "Upload Attachments by tapping here\nSupports: .pdf, .docx, .ppsx, .pptx, .odp",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF7B7E8B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF139CFF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          onPressed: () {
            // Add your logic for adding new material
          },
          child: const Text(
            "Add New Material",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6A7F),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class DashedRect extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRect({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path();
    double x = 0, y = 0;
    while (x < size.width) {
      path.moveTo(x, 0);
      path.lineTo(x + gap, 0);
      x += gap * 2;
    }
    while (y < size.height) {
      path.moveTo(size.width, y);
      path.lineTo(size.width, y + gap);
      y += gap * 2;
    }
    x = size.width;
    while (x > 0) {
      path.moveTo(x, size.height);
      path.lineTo(x - gap, size.height);
      x -= gap * 2;
    }
    y = size.height;
    while (y > 0) {
      path.moveTo(0, y);
      path.lineTo(0, y - gap);
      y -= gap * 2;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
