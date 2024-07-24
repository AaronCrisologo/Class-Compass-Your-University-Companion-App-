import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    // Announcement Screen Data
    {
      'title': 'Class Announcement',
      'description':
          'Please be advised that a power outage is scheduled to occur on August 14 from 10:00 am to 12:00pm. Due to this outage, all classes scheduled during this time may be canceled or rescheduled.',
      'type': 'class',
      'date': DateTime.now().add(Duration(days: 5)),
      'expanded': false,
    },
    {
      'title': 'Batangas State University Library - Alangilan',
      'description':
          'The campus library will be closed on July 24 for a staff training event. Please plan your visits accordingly. Online resources will still be available during this time.',
      'type': 'announcement',
      'date': DateTime(2024, 7, 24),
      'profilePic': 'assets/bsulib.jpg',
      'expanded': false,
    },
    {
      'title': 'No Classes - National Holiday',
      'description':
          'There will be no classes on tomorrow, August 9 2024, due to Ninoy Aquino Day celebration. Enjoy your holiday!',
      'type': 'holiday',
      'date': DateTime(2024, 7, 20),
      'expanded': false,
    },
    {
      'title': 'Partial Asychronous Classes',
      'description':
          'There will be a partial no class on July 22 from 10:00 AM to 12:00 PM due to maintenance work in the building. Classes during this time will be asynchronous. Please check your email for further instructions from your professors.',
      'type': 'custom_event',
      'date': DateTime(2024, 7, 22),
      'expanded': false,
    },
    {
      'title': 'CICS Alangilan - Student Council',
      'description':
          'The Student Council will be holding a virtual town hall meeting on July 18 at 3:00 PM. All students are encouraged to attend and voice their concerns. Your participation is important for making positive changes on campus.',
      'type': 'announcement',
      'date': DateTime(2024, 7, 18),
      'profilePic': 'assets/cics_sc.jpg',
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
      'title': 'College of Informatics and Computing Sciences - CICS',
      'description':
          'In light of the upcoming University Festival, all classes scheduled for July 23, 2024 will be suspended to allow everyone to participate and enjoy the festivities. This event is a great opportunity to engage with your peers and take part in various exciting activities organized by the student body.',
      'type': 'announcement',
      'date': DateTime.now().add(Duration(days: 1)),
      'profilePic': 'assets/cics.jpg',
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
  final int maxChars = 100;

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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            notification['expanded']
                ? Text(
                    notification['description'],
                    style: TextStyle(fontSize: 14),
                  )
                : Text(
                    notification['description'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
            if (!notification['expanded'] &&
                notification['description'].length > maxChars)
              InkWell(
                onTap: onToggleExpanded,
                child: Text(
                  'Read more',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
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
