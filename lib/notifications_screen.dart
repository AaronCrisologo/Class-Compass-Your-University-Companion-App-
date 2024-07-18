import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    // Announcement Screen Data
    {
      'title': 'Library Closure',
      'description':
          'The campus library will be closed on July 24 for a staff training event. Please plan your visits accordingly. Online resources will still be available during this time.',
      'type': 'announcement',
      'date': DateTime(2024, 7, 24),
      'profilePic': 'https://via.placeholder.com/150',
      'expanded': false,
    },
    {
      'title': 'Career Fair Announcement',
      'description':
          'A career fair will be held on July 25 from 9:00 AM to 4:00 PM in the main hall. Students are encouraged to bring their resumes and meet with potential employers. Don’t miss this opportunity to network and explore job opportunities.',
      'type': 'announcement',
      'date': DateTime(2024, 7, 25),
      'profilePic': 'https://via.placeholder.com/150',
      'expanded': false,
    },
    {
      'title': 'No Classes - National Holiday',
      'description':
          'There will be no classes on July 20 due to the National Independence Day celebration. Enjoy your holiday!',
      'type': 'holiday',
      'date': DateTime(2024, 7, 20),
      'expanded': false,
    },
    {
      'title': 'Weather Alert - Typhoon Warning',
      'description':
          'Classes are suspended on July 21 due to an incoming typhoon. Stay safe and stay indoors. Please keep updated with the latest news and weather reports.',
      'type': 'weather',
      'date': DateTime(2024, 7, 21),
      'expanded': false,
    },
    {
      'title': 'Partial No Class - Maintenance',
      'description':
          'There will be a partial no class on July 22 from 10:00 AM to 12:00 PM due to maintenance work in the building. Classes during this time will be asynchronous. Please check your email for further instructions from your professors.',
      'type': 'custom_event',
      'date': DateTime(2024, 7, 22),
      'expanded': false,
    },
    {
      'title': 'Student Council Announcement',
      'description':
          'The Student Council will be holding a virtual town hall meeting on July 18 at 3:00 PM. All students are encouraged to attend and voice their concerns. Your participation is important for making positive changes on campus.',
      'type': 'announcement',
      'date': DateTime(2024, 7, 18),
      'profilePic': 'https://via.placeholder.com/150',
      'expanded': false,
    },
    {
      'title': 'Upcoming Math Class',
      'description':
          'Don’t forget your Math class with Professor Smith at 10:00 AM. Be prepared and bring your homework. Please be on time and review the materials beforehand.',
      'type': 'class',
      'date': DateTime.now().add(Duration(hours: 1)),
      'expanded': false,
    },
    {
      'title': 'Reminder - Assignment Due',
      'description':
          'Your assignment for the Data Structures class is due tomorrow. Make sure to submit it before midnight. Please double-check your work and submit via the portal.',
      'type': 'class',
      'date': DateTime.now().add(Duration(days: 1)),
      'expanded': false,
    },
    {
      'title': 'COVID-19 Safety Measures Update',
      'description':
          'Please adhere to the updated COVID-19 safety measures on campus. Wear masks at all times, maintain social distancing, and sanitize your hands regularly. Let’s work together to keep our community safe.',
      'type': 'announcement',
      'date': DateTime(2024, 7, 17),
      'profilePic': 'https://via.placeholder.com/150',
      'expanded': false,
    },
  ];

  void _archiveNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification archived'),
      ),
    );
  }

  void _toggleExpanded(int index) {
    setState(() {
      notifications[index]['expanded'] = !notifications[index]['expanded'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Dismissible(
            key: Key(notification['title']),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _archiveNotification(index);
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Removing...', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            child: NotificationCard(
              notification: notification,
              onToggleExpanded: () => _toggleExpanded(index),
            ),
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onToggleExpanded;
  final int maxChars = 100; // Max characters before showing "Read More"

  NotificationCard({
    required this.notification,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

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
      child: ListTile(
        leading: notification['type'] == 'announcement'
            ? CircleAvatar(
                backgroundImage: NetworkImage(notification['profilePic']),
              )
            : CircleAvatar(
                backgroundColor: iconColor,
                child: Icon(icon, color: Colors.white),
              ),
        title: Text(notification['title'],
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            notification['expanded']
                ? Text(notification['description'])
                : Text(
                    notification['description'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
            if (!notification['expanded'] &&
                notification['description'].length > maxChars)
              InkWell(
                onTap: onToggleExpanded,
                child: Text(
                  'Read more',
                  style: TextStyle(color: Colors.blue),
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
    );
  }
}
