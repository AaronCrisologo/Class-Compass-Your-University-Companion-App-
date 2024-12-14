import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For API calls

import 'add_announcement_screen.dart';
import 'add_calendar_screen.dart';
import 'login_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  String? _adminEmail;
  bool _isLoading = true;

  static final List<Widget> _adminOptions = <Widget>[
    Center(child: Text('Admin Home')),
    AddAnnouncementScreen(),
    AddCalendarScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
  }

  Future<void> _fetchAdminData() async {
    final String apiUrl = 'https://ggbg0m6m-3000.asse.devtunnels.ms/accounts/get-email'; // Replace with your API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _adminEmail = data['email'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _adminEmail = 'Error fetching email';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _adminEmail = 'Error fetching email';
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        centerTitle: false,
                actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildAdminHome()
          : _adminOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add Announcement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Add Calendar',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAdminHome() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            // Welcome Message
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome, ',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        TextSpan(
                          text: '${_adminEmail ?? 'Admin'} Admin',
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
            SizedBox(height: 32),

            // Warnings Section
            Text(
              '⚠️ Warnings:',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            _buildWarningTile(
                'Editing values here will affect all users. Proceed with caution.'),
            _buildWarningTile(
                'Changes to announcements and calendar events are immediate.'),
            _buildWarningTile(
                'Ensure that all data entered is accurate and properly formatted.'),
            _buildWarningTile(
                'Unauthorized use of this section can lead to data corruption.'),
            _buildWarningTile(
                'All changes are logged for audit purposes. Ensure compliance with data policies.'),

            SizedBox(height: 32),

            // Disclaimer Section
            Text(
              '📜 Disclaimer:',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              'This section is strictly for administrative purposes. Any misuse of the controls or features can lead to system instability or data loss. Admins are advised to double-check all changes before saving.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            SizedBox(height: 32),

            // Responsibilities Section
            Text(
              '🛡 Responsibilities:',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            _buildResponsibilityTile(
                'Ensure the accuracy of all data entered into the system.'),
            _buildResponsibilityTile(
                'Notify relevant stakeholders before making significant changes.'),
            _buildResponsibilityTile(
                'Adhere to institutional policies and guidelines when managing data.'),
            _buildResponsibilityTile(
                'Take full responsibility for any unintended consequences of changes.'),

            SizedBox(height: 32),

            // Additional Information
            Text(
              'Choose an option from the bottom navigation bar to manage announcements or the calendar.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningTile(String warningText) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(child: Text(warningText)),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsibilityTile(String responsibilityText) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 12),
            Expanded(child: Text(responsibilityText)),
          ],
        ),
      ),
    );
  }
}