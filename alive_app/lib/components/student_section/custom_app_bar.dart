import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final bool isDarkMode;
  final int selectedDrawerIndex;
  final List<String> drawerItems;
  final ValueChanged<bool> onDarkModeToggle;
  final VoidCallback onLogout;

  const CustomAppBar({
    super.key,
    required this.isDarkMode,
    required this.selectedDrawerIndex,
    required this.drawerItems,
    required this.onDarkModeToggle,
    required this.onLogout,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _buildMenuButton(context),
      title: Text(
        widget.drawerItems[widget.selectedDrawerIndex],
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        _buildSettingsButton(context),
        _buildProfileButton(context),
      ],
    );
  }

  IconButton _buildMenuButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: Colors.black),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }

  IconButton _buildSettingsButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
      onPressed: () {
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(
              150.0, 100.0, -50.0, 0.0), // adjust these as needed
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

  GestureDetector _buildProfileButton(BuildContext context) {
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
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Text(
                        'Y',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Yimkumer Pongen',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'AIT22MCAV043',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'Student',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.logout, color: Colors.red),
                        GestureDetector(
                          onTap: widget.onLogout,
                          child: const Text('Logout',
                              style: TextStyle(color: Colors.red)),
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
      child: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          'Y',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
