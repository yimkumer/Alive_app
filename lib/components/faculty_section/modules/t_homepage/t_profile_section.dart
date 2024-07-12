import 'package:flutter/material.dart';
import '../../faculty_details.dart';

class TProfileSection extends StatefulWidget {
  final String token;

  const TProfileSection({super.key, required this.token});

  @override
  State<TProfileSection> createState() => _TProfileSectionState();
}

class _TProfileSectionState extends State<TProfileSection> {
  String facultyName = '';
  String branchName = '';
  late faculty_details _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = faculty_details(token: widget.token, context: context);
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    var userData = await _apiService.fetchUserData();
    setState(() {
      facultyName = userData['employee_name'] ?? '';
      branchName = userData['branch_name'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isNarrow = maxWidth < 600;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 0, isNarrow ? 5 : 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome ${facultyName.split(' ').first}!",
                  style: const TextStyle(
                    color: Color(0xFF05004E),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(isNarrow ? 10 : 20),
              padding: EdgeInsets.all(isNarrow ? 10 : 20),
              height: isNarrow ? 150 : 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: const AssetImage('assets/t-bg.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.61),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: isNarrow ? 2 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.fromLTRB(0, isNarrow ? 15 : 0, 10, 0),
                          width: isNarrow ? 90 : 100,
                          height: isNarrow ? 90 : 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              facultyName.isNotEmpty ? facultyName[0] : 'F',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: isNarrow ? 4 : 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          facultyName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isNarrow ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          branchName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
