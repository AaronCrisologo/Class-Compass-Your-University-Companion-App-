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
      'accountName': 'CABEIHM Student Council',
      'message':
          'ACADEMIC BREAK: NO CLASSES on November 2-6, 2022. In light of the ongoing challenge caused by Typhoon Paeng, the University Student Council stands with you in providing assistance and support to students and their families who were severely affected by the typhoon in order to assist them in recovering completely from the chaos. Please be guided accordingly. #ZitoRedSpartans',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
    {
      'profilePicture': Icons.account_circle, // Placeholder for profile picture
      'accountName': 'CABEIHM Student Council',
      'message':
          'ACADEMIC BREAK: NO CLASSES on November 2-6, 2022. In light of the ongoing challenge caused by Typhoon Paeng, the University Student Council stands with you in providing assistance and support to students and their families who were severely affected by the typhoon in order to assist them in recovering completely from the chaos. Please be guided accordingly. #ZitoRedSpartans',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
    {
      'profilePicture': Icons.account_circle, // Placeholder for profile picture
      'accountName': 'CABEIHM Student Council',
      'message':
          'ATTENTION, CABEIHMKADA! As per the directives outlined in Memorandum Order No. 572, there will be asynchronous classes in all levels scheduled for tomorrow, on November 3, 2022. It is with consideration of the celebration of All Saints\' Day, providing both students and faculty an opportunity to spend time with their families. Source: Office of the University President #CABEIHMAboveandBeyond',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
    {
      'profilePicture': Icons.account_circle, // Placeholder for profile picture
      'accountName': 'Supreme Student Council - BatStateU Alangilan Campus',
      'message':
          'In view of Typhoon Signal Number 2 being raised over Eastern Batangas due to Typhoon Paeng, classes are hereby suspended both synchronous and asynchronous on October 29, 2022, Saturday. Keep safe and stay dry, Red Spartans! #WalangPasok #TyphoonKarding',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
    {
      'profilePicture': Icons.account_circle, // Placeholder for profile picture
      'accountName': 'Supreme Student Council - BatStateU Alangilan Campus',
      'message':
          'ANNOUNCEMENT: NO CLASSES Source: Official Gazette Pursuant to Proclamation No. 986 of the President, April 9, 2021 (Friday) was declared as a regular holiday to commemorate the Araw ng Kagitingan. #ZitoRedSpartans',
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
          'Classes will be suspended on all campuses today, April 10, 2017. Only faculty members and employees are expected to report to work. Please be guided accordingly. Dissemination of this advisory to all concerned is desired. Source: Office of the President, Batangas State University',
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
          'Due to the moderate and heavy rains brought by Tropical Depression Florita, and by recommendation of the Batangas City Mayor, Face-to-Face and Online Classes in ALL LEVELS of BatStateU Pablo Borbon and BatStateU Alangilan are hereby suspended today, August 24. Please observe safety precautions until the situation has normalized.',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
    },
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
          'Typhoon Signal Number 3 is raised in our area. Classes are suspended until further notice.',
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
      announcement['expanded'] = false; // Initialize expanded state
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

  void _toggleExpanded(int index) {
    setState(() {
      announcements[index]['expanded'] = !announcements[index]['expanded'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        // Determine the maximum characters to display before "Read more"
        int maxCharacters = 200;
        bool showReadMore = announcement['message'].length > maxCharacters &&
            !announcement['expanded'];
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
                  title: Text(
                    announcement['accountName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: announcement['message'].substring(
                                  0,
                                  announcement['accountName']
                                      .toString()
                                      .length), // Excluding profile name from truncation
                            ),
                            TextSpan(
                              text: showReadMore
                                  ? '${announcement['message'].substring(announcement['accountName'].toString().length, maxCharacters)}...'
                                  : announcement['message'].substring(
                                      announcement['accountName']
                                          .toString()
                                          .length), // Showing remaining message
                            ),
                          ],
                        ),
                      ),
                      if (showReadMore)
                        TextButton(
                          onPressed: () {
                            _toggleExpanded(index); // Toggle expanded state
                          },
                          child: Text('Read more'),
                        ),
                      if (announcement[
                          'expanded']) // Show full message if expanded
                        Text(
                          announcement['message'].substring(
                              announcement['accountName']
                                  .toString()
                                  .length), // Excluding profile name
                        ),
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
