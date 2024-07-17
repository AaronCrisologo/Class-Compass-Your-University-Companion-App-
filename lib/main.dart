import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'notifications_screen.dart';
import 'announcements_screen.dart';
import 'schedule_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

void main() => runApp(ClassCompassApp());

class ClassCompassApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Compass',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    NotificationScreen(),
    AnnouncementsScreen(),
    ScheduleScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Class Compass';
      case 1:
        return 'Calendar';
      case 2:
        return 'Notifications';
      case 3:
        return 'Announcements';
      case 4:
        return 'Schedule';
      default:
        return 'Class Compass';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(_selectedIndex),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.bullhorn,
            ),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.red,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("user@example.com"),
              currentAccountPicture: GestureDetector(
                onTap: _navigateToProfile,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    "U",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Profile'),
              onTap: _navigateToProfile,
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Class'),
              onTap: () {
                // Implement Add Class functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Resources'),
              onTap: () {
                // Implement Resources functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.archive),
              title: Text('Notification Archive'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
