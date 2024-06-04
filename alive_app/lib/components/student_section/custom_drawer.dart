import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedDrawerIndex;
  final List<String> drawerItems;
  final List<IconData> drawerIcons;
  final ValueChanged<int> onItemSelected;

  const CustomDrawer({
    super.key,
    required this.selectedDrawerIndex,
    required this.drawerItems,
    required this.drawerIcons,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF030034),
              Color(0xFF040042),
              Color(0xFF06005B),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _buildHeader(),
            ..._buildDrawerItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 100,
      child: SizedBox(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildLogo(),
              const SizedBox(width: 10),
              _buildTitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/alivelogo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alive',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Digital Classrooms",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    return List.generate(drawerItems.length, (index) {
      return Container(
        decoration: BoxDecoration(
          color: selectedDrawerIndex == index
              ? const Color(0xFFEEBBC2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(07.0),
        ),
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(drawerIcons[index],
              color: selectedDrawerIndex == index
                  ? const Color(0xff161b44)
                  : Colors.white,
              size: 20),
          title: Text(
            drawerItems[index],
            style: TextStyle(
                color: selectedDrawerIndex == index
                    ? const Color(0xFF161B44)
                    : Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15),
          ),
          onTap: () {
            onItemSelected(index);
            Navigator.pop(context);
          },
        ),
      );
    });
  }
}
