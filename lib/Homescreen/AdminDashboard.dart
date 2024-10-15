import 'package:flutter/material.dart';
import 'package:nandini_beauty_store/Homescreen/HomePage.dart';
import 'package:nandini_beauty_store/Modeles/AddProducts.dart';
import 'package:nandini_beauty_store/Modeles/EditProducts.dart';
import 'package:nandini_beauty_store/Others/BottomNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  final List<Map<String, dynamic>> _dashboardItems = [
    {'title': 'Add Products', 'icon': Icons.add_box, 'page': AddProductPage(refreshHomePage: () {})},
    {'title': 'Update Products', 'icon': Icons.update, 'page': AddProductPage(refreshHomePage: () {})},
    {'title': 'Delete Products', 'icon': Icons.delete, 'page': AddProductPage(refreshHomePage: () {})},
    {'title': 'Add Categories', 'icon': Icons.category, 'page': AddProductPage(refreshHomePage: () {})},
    {'title': 'Users', 'icon': Icons.people, 'page': AddProductPage(refreshHomePage: () {})},
    {'title': 'Comments', 'icon': Icons.comment, 'page': AddProductPage(refreshHomePage: () {})},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: Color(0xffFF1694),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Panel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings page
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        itemCount: _dashboardItems.length,
        itemBuilder: (context, index) {
          final item = _dashboardItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item['page']),              // Create a new instance of the page
              );
            },
            child: _buildGridItem(item),
          );
        },
      ),
    );
  }

  Widget _buildGridItem(Map<String, dynamic> item) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item['icon'], size: 40.0),
          SizedBox(height: 10.0),
          Text(
            item['title'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    setState(() {
      _isLoggedIn = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}
