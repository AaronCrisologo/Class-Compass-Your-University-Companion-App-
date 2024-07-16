import 'package:flutter/material.dart';
import 'dart:math';

class AnnouncementsScreen extends StatefulWidget {
  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final Random _random = Random();
  final DateTime _currentDate = DateTime(2024, 8, 9);

  // Mock announcement data
  final List<Map<String, dynamic>> announcements = [
    {
      'profilePicture': Icons.account_circle, // Placeholder for profile picture
      'accountName': 'Supreme Student Council - BatStateU Alangilan Campus',
      'message':
          'Classes are suspended tomorrow due to typhoon warnings. Stay safe everyone!',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
    {
      'profilePicture': Icons.account_circle, // Placeholder for profile picture
      'accountName': 'CICS Alangilan - Student Council',
      'message':
          'No classes on Monday for the school holiday. Enjoy your long weekend!',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
    {
      'profilePicture': Icons.account_circle, // Placeholder for profile picture
      'accountName': 'College of Informatics and Computing Sciences - CICS',
      'message':
          'Class schedules will be adjusted due to ongoing repairs in the main building. Check the updated schedule on our website.',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
    {
      'profilePicture': Icons.account_circle, // Placeholder for profile picture
      'accountName': 'Walang Pasok',
      'message':
          'Classes are suspended today due to heavy rainfall and flooding in the area. Stay dry and safe!',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
    {
      'profilePicture': Icons.account_circle, // Placeholder for profile picture
      'accountName': 'Batangas PIO',
      'message':
          'Typhoon signal number 3 is raised in our area. Classes are suspended until further notice.',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
    {
      'profilePicture': Icons.account_circle, // Placeholder for profile picture
      'accountName': 'PAG-ASA',
      'message':
          'Weather update: Typhoon approaching. Please monitor local news for announcements on class suspensions.',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize likes, dislikes, and dates with random values
    for (var announcement in announcements) {
      announcement['likes'] = _random.nextInt(5000);
      announcement['dislikes'] = _random.nextInt(5000);
      announcement['date'] = _randomDate();
    }
  }

  DateTime _randomDate() {
    int daysAgo = _random.nextInt(30); // Generate a random number of days ago
    return _currentDate.subtract(Duration(days: daysAgo));
  }

  void _toggleLike(int index) {
    setState(() {
      if (announcements[index]['liked']) {
        announcements[index]['likes']--;
        announcements[index]['liked'] = false;
      } else {
        announcements[index]['likes']++;
        announcements[index]['liked'] = true;
        if (announcements[index]['disliked']) {
          announcements[index]['dislikes']--;
          announcements[index]['disliked'] = false;
        }
      }
    });
  }

  void _toggleDislike(int index) {
    setState(() {
      if (announcements[index]['disliked']) {
        announcements[index]['dislikes']--;
        announcements[index]['disliked'] = false;
      } else {
        announcements[index]['dislikes']++;
        announcements[index]['disliked'] = true;
        if (announcements[index]['liked']) {
          announcements[index]['likes']--;
          announcements[index]['liked'] = false;
        }
      }
    });
  }

  void _toggleNotification(int index) {
    setState(() {
      announcements[index]['notifications'] =
          !announcements[index]['notifications'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            announcements[index]['notifications']
                ? 'Notification added.'
                : 'Notification removed.',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return Card(
          margin: EdgeInsets.all(10.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    announcement['profilePicture'],
                    size: 40.0,
                  ),
                  title: Text(announcement['accountName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(announcement['message']),
                      SizedBox(height: 5.0),
                      Text(
                        _formatDate(announcement['date']),
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                ButtonBar(
                  children: [
                    TextButton.icon(
                      icon: Icon(
                        Icons.thumb_up,
                        color:
                            announcement['liked'] ? Colors.blue : Colors.grey,
                      ),
                      label: Text('${announcement['likes']}'),
                      onPressed: () => _toggleLike(index),
                    ),
                    TextButton.icon(
                      icon: Icon(
                        Icons.thumb_down,
                        color:
                            announcement['disliked'] ? Colors.red : Colors.grey,
                      ),
                      label: Text('${announcement['dislikes']}'),
                      onPressed: () => _toggleDislike(index),
                    ),
                    TextButton.icon(
                      icon: Icon(
                        Icons.notifications,
                        color: announcement['notifications']
                            ? Colors.yellow
                            : Colors.grey,
                      ),
                      label: Text('Notify'),
                      onPressed: () => _toggleNotification(index),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
