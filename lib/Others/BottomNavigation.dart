import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavigation({required this.currentIndex, required this.onTap});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  bool _isAdmin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('isAdmin') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xffFF1694),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home_outlined),color: Colors.white,
            onPressed: () => widget.onTap(0),
          ),
          if (_isAdmin) // Show Dashboard icon only if admin
            IconButton(
              icon: const Icon(Icons.dashboard_customize),
              color: Colors.white,
              onPressed: () => widget.onTap(1),
            ),
          IconButton(
            icon: Icon(Icons.star_border),color: Colors.white,
            onPressed: () => widget.onTap(2),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined),color: Colors.white,
            onPressed: () => widget.onTap(3),
          ),
        ],
      ),
    );
  }
}