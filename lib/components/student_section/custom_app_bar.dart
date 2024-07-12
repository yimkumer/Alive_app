import 'package:flutter/material.dart';
import 'student_details.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final bool isDarkMode;
  final int selectedDrawerIndex;
  final List<String> drawerItems;
  final ValueChanged<bool> onDarkModeToggle;
  final VoidCallback onLogout;
  final String token;

  const CustomAppBar({
    super.key,
    required this.isDarkMode,
    required this.selectedDrawerIndex,
    required this.drawerItems,
    required this.onDarkModeToggle,
    required this.onLogout,
    required this.token,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late student_details _apiService;
  String userName = '';
  String userId = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _apiService = student_details(token: widget.token, context: context);
    fetchUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = student_details(token: widget.token, context: context);
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    var userData = await _apiService.fetchUserData();
    setState(() {
      userName = userData['student_name'] ?? '';
      userId = userData['user_id'] ?? '';
      userRole = userData['user_role'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildProfileButton(),
          const SizedBox(width: 10),
          Image.asset(
            'assets/logor.png',
            height: 30,
            width: 30,
          ),
          const Text(
            "Alive",
            style: TextStyle(
                color: Color(0xff05004E),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        _buildSettingsButton(),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.black,
          height: 0.2,
        ),
      ),
    );
  }

  IconButton _buildSettingsButton() {
    return IconButton(
      icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
      onPressed: () {
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(150.0, 100.0, -50.0, 0.0),
          items: [
            PopupMenuItem(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SwitchListTile(
                    title: Text(widget.isDarkMode ? 'Dark Mode' : 'Light Mode'),
                    value: widget.isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        widget.onDarkModeToggle(value);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  GestureDetector _buildProfileButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                height: 200,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Text(
                        userName.isNotEmpty ? userName[0] : 'S',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      userId,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      userRole,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.logout, color: Colors.red),
                        GestureDetector(
                          onTap: widget.onLogout,
                          child: const Text('Logout',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 18)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          userName.isNotEmpty ? userName[0] : 'S',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15),
        ),
      ),
    );
  }
}
