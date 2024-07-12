import 'package:flutter/material.dart';
import '../../student_details.dart';

class ProfileSection extends StatefulWidget {
  final String token;

  const ProfileSection({super.key, required this.token});

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  String studentName = '';
  String courseBranch = '';
  String instituteName = '';
  late student_details _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = student_details(token: widget.token, context: context);
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    var userData = await _apiService.fetchUserData();
    setState(() {
      studentName = userData['student_name'] ?? '';
      courseBranch = userData['course_branch_short_name'] ?? '';
      instituteName = userData['institute_name_short'] ?? '';
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
                child: () {
                  return Text(
                    "Welcome ${studentName.split(' ').first}!",
                    style: const TextStyle(
                      color: Color(0xFF05004E),
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                  );
                }(),
              ),
            ),
            Container(
              margin: EdgeInsets.all(isNarrow ? 10 : 20),
              padding: EdgeInsets.all(isNarrow ? 10 : 20),
              height: isNarrow ? 150 : 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFD5DF3A),
                    Color(0xFF3EB921),
                    Color(0xFF00A917),
                  ],
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
                              studentName.isNotEmpty ? studentName[0] : 'S',
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
                          studentName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isNarrow ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '$courseBranch Branch',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          instituteName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/1.png',
                          height: isNarrow ? 50 : 60,
                          width: isNarrow ? 50 : 60,
                        ),
                        Container(
                          color: Colors.black,
                          width: isNarrow ? 45 : 55,
                          child: Text(
                            'Grade',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isNarrow ? 12 : 14,
                            ),
                            textAlign: TextAlign.center,
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
