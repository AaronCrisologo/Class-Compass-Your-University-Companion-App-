import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _is24HourFormat = false;

  void _showBugReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report a Bug'),
          content: TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText:
                  'Please detail and explain the specific bug you encountered...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Implement bug report submission
                Navigator.of(context).pop();
                _showThankYouDialog();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank You'),
          content: Text('Thank you for reporting the bug!'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text('English'),
                  trailing: Icon(Icons.check_circle, color: Colors.blue),
                  onTap: () {
                    // Implement language selection
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Spanish'),
                  onTap: () {
                    // Implement language selection
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('French'),
                  onTap: () {
                    // Implement language selection
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('German'),
                  onTap: () {
                    // Implement language selection
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Chinese'),
                  onTap: () {
                    // Implement language selection
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Japanese'),
                  onTap: () {
                    // Implement language selection
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Korean'),
                  onTap: () {
                    // Implement language selection
                    Navigator.of(context).pop();
                  },
                ),
                // Add more languages if needed
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Toggle dark and light theme'),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('24-Hour Clock'),
            subtitle: Text('Toggle between 12-hour and 24-hour clock'),
            value: _is24HourFormat,
            onChanged: (bool value) {
              setState(() {
                _is24HourFormat = value;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Change app language'),
            onTap: _showLanguageSelectionDialog,
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification Settings'),
            subtitle: Text('Manage notification preferences'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationSettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy and Security'),
            subtitle: Text('Manage privacy and security settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PrivacySecuritySettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bug_report),
            title: Text('Report a Bug'),
            subtitle: Text('Report any bugs you encounter'),
            onTap: _showBugReportDialog,
          ),
        ],
      ),
    );
  }
}

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _doNotDisturb = false;
  bool _reminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Do Not Disturb'),
            subtitle: Text('Silence all notifications'),
            value: _doNotDisturb,
            onChanged: (bool value) {
              setState(() {
                _doNotDisturb = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Class Reminder'),
            subtitle: Text('Remind about no classes the day before'),
            value: _reminder,
            onChanged: (bool value) {
              setState(() {
                _reminder = value;
              });
            },
          ),
          // Add more notification settings if needed
        ],
      ),
    );
  }
}

class PrivacySecuritySettingsScreen extends StatefulWidget {
  @override
  _PrivacySecuritySettingsScreenState createState() =>
      _PrivacySecuritySettingsScreenState();
}

class _PrivacySecuritySettingsScreenState
    extends State<PrivacySecuritySettingsScreen> {
  bool _locationTracking = false;
  bool _dataSharing = false;
  bool _adPersonalization = false;
  bool _passwordProtection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy and Security Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Location Tracking'),
            subtitle: Text('Allow the app to track your location'),
            value: _locationTracking,
            onChanged: (bool value) {
              setState(() {
                _locationTracking = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Data Sharing'),
            subtitle: Text('Share data with third-party services'),
            value: _dataSharing,
            onChanged: (bool value) {
              setState(() {
                _dataSharing = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Ad Personalization'),
            subtitle: Text('Allow personalized ads based on your data'),
            value: _adPersonalization,
            onChanged: (bool value) {
              setState(() {
                _adPersonalization = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Password Protection'),
            subtitle: Text('Enable password protection for the app'),
            value: _passwordProtection,
            onChanged: (bool value) {
              setState(() {
                _passwordProtection = value;
              });
            },
          ),
          // Add more privacy and security settings if needed
        ],
      ),
    );
  }
}
