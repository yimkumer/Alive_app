import 'package:flutter/material.dart';
import 'faculty_details.dart';

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
  late faculty_details _apiService;
  String userName = '';
  String userId = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _apiService = faculty_details(token: widget.token, context: context);
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      var userData = await _apiService.fetchUserData();
      setState(() {
        userName = userData['employee_name'] ?? '';
        userId = userData['empcode'] ?? '';
        userRole = userData['lms_role'] ?? '';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildProfileButton(context),
          const SizedBox(width: 10),
          Image.asset(
            'assets/logor.png',
            height: 30,
            width: 30,
          ),
          const Text(
            "Alive",
            style: TextStyle(
              color: Color(0xFF05004E),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        _buildSettingsButton(context),
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

  Widget _buildSettingsButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
      onPressed: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset.zero, ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(Offset.zero),
                ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );

        showMenu(
          context: context,
          position: position,
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

  Widget _buildProfileButton(BuildContext context) {
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
                        userName.isNotEmpty ? userName[0] : 'F',
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
                    GestureDetector(
                      onTap: widget.onLogout,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 5),
                          Text('Logout',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 18)),
                        ],
                      ),
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
          userName.isNotEmpty ? userName[0] : 'F',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15),
        ),
      ),
    );
  }
}
