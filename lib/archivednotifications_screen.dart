import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ArchivedNotificationsScreen extends StatefulWidget {
  @override
  _ArchivedNotificationsScreenState createState() =>
      _ArchivedNotificationsScreenState();
}

class _ArchivedNotificationsScreenState
    extends State<ArchivedNotificationsScreen> {
  final List<Map<String, dynamic>> archivedNotifications = [
    // Mock data for archived notifications
    {
      'title': 'Library Closure',
      'description':
          'The campus library will be closed on July 24 for a staff training event. Please plan your visits accordingly. Online resources will still be available during this time.',
      'type': 'announcement',
      'date': DateTime(2024, 7, 24),
      'profilePic': 'assets/bsulib.jpg',
      'expanded': false,
    },
    {
      'title': 'Reminder',
      'description':
          'A career fair will be held on July 25 from 9:00 AM to 4:00 PM in the main hall. Students are encouraged to bring their resumes and meet with potential employers. Don’t miss this opportunity to network and explore job opportunities.',
      'type': 'announcement',
      'date': DateTime(2024, 7, 25),
      'profilePic': 'Icons.notification',
      'expanded': false,
    },
  ];

  void _restoreNotification(int index) {
    setState(() {
      archivedNotifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification restored'),
      ),
    );
  }

  void _deleteNotification(int index) {
    setState(() {
      archivedNotifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification deleted permanently'),
      ),
    );
  }

  void _toggleExpanded(int index) {
    setState(() {
      archivedNotifications[index]['expanded'] =
          !archivedNotifications[index]['expanded'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Archived Notifications',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: archivedNotifications.length,
        itemBuilder: (context, index) {
          final notification = archivedNotifications[index];
          return ArchivedNotificationCard(
            notification: notification,
            onRestore: () => _restoreNotification(index),
            onDelete: () => _deleteNotification(index),
            onToggleExpanded: () => _toggleExpanded(index),
          );
        },
      ),
    );
  }
}

class ArchivedNotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onRestore;
  final VoidCallback onDelete;
  final VoidCallback onToggleExpanded;
  final int maxChars = 100; // Max characters before showing "Read More"

  ArchivedNotificationCard({
    required this.notification,
    required this.onRestore,
    required this.onDelete,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    // Set icon and color based on notification type
    switch (notification['type']) {
      case 'holiday':
        icon = Icons.celebration;
        iconColor = Colors.redAccent;
        break;
      case 'weather':
        icon = Icons.wb_cloudy;
        iconColor = Colors.blueAccent;
        break;
      case 'class':
        icon = Icons.class_;
        iconColor = Colors.greenAccent;
        break;
      case 'custom_event':
        icon = Icons.event;
        iconColor = Colors.orangeAccent;
        break;
      case 'announcement':
        icon = Icons.announcement;
        iconColor = Colors.purpleAccent;
        break;
      default:
        icon = Icons.notifications;
        iconColor = Colors.grey;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: notification['title'] == 'Reminder'
                  ? CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.event_note, color: Colors.white),
                    )
                  : notification['type'] == 'announcement'
                      ? CircleAvatar(
                          backgroundImage:
                              AssetImage(notification['profilePic']),
                        )
                      : CircleAvatar(
                          backgroundColor: iconColor,
                          child: Icon(icon, color: Colors.white),
                        ),
              title: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  notification['expanded']
                      ? Text(notification['description'])
                      : RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: notification['description'].length >
                                        maxChars
                                    ? '${notification['description'].substring(0, maxChars)}...'
                                    : notification['description'],
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              if (notification['description'].length > maxChars)
                                TextSpan(
                                  text: 'Read more',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = onToggleExpanded,
                                ),
                            ],
                          ),
                        ),
                  SizedBox(height: 5),
                  Text(
                    '${notification['date'].day}/${notification['date'].month}/${notification['date'].year} at ${notification['date'].hour}:${notification['date'].minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onRestore,
                  child: Text(
                    'Restore',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: onDelete,
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
