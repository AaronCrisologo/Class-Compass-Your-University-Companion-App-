import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
      'profilePicture': 'assets/cabeihm.jpg',
      'accountName': 'CABEIHM Student Council',
      'message':
          'ACADEMIC BREAK: NO CLASSES on August 2-6, 2024. In light of the ongoing challenge caused by the Typhoon, the University Student Council stands with you in providing assistance and support to students and their families who were severely affected by the typhoon in order to assist them in recovering completely from the chaos. Please be guided accordingly. #ZitoRedSpartans',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/wpa.jpg',
      'accountName': 'Walang Pasok Advisory',
      'message':
          '#WalangPasokAdvisory: Malacañang declares Monday, Jul 17, a regular holiday in observance of Eidl Adha. Proclamation No. 579 signed by Executive Secretary Lucas Bersamin was released yesterday, June 5, 2024.',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/batspio.jpg',
      'accountName': 'Batangas PIO',
      'message':
          'Upon the recommendation of the Provincial Disaster Risk Reduction and Management Office, and in view of the continuing inclement weather due to the effects of TS Florita (moderate to heavy rains) the Provincial Government of Batangas, as per Gov. DoDo Mandanas, declares that classes, in private and public schools, from kindergarten to senior high school, are suspended tomorrow, 24 August 2022, in the whole Province of Batangas. Stay safe Batangueños! God bless.',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/cics.jpg',
      'accountName': 'College of Informatics and Computing Sciences - CICS',
      'message':
          'Classes will be suspended on all campuses today, April 10, 2024. Only faculty members and employees are expected to report to work. Please be guided accordingly. Dissemination of this advisory to all concerned is desired. Source: Office of the President, Batangas State University',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/cabeihm.jpg',
      'accountName': 'CABEIHM Student Council',
      'message':
          'ATTENTION, CABEIHMKADA! As per the directives outlined in Memorandum Order No. 572, there will be asynchronous classes in all levels scheduled for tomorrow, on July 3, 2024. It is with consideration of the celebration of All Saints\' Day, providing both students and faculty an opportunity to spend time with their families. Source: Office of the University President #CABEIHMAboveandBeyond',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/BSUSSC.png',
      'accountName': 'Supreme Student Council - BatStateU Alangilan Campus',
      'message':
          'In view of Typhoon Signal Number 2 being raised over Eastern Batangas due to Typhoon Paeng, classes are hereby suspended both synchronous and asynchronous on October 29, 2022, Saturday. Keep safe and stay dry, Red Spartans! #WalangPasok #TyphoonKarding',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/cics_sc.jpg',
      'accountName': 'CICS Alangilan - Student Council',
      'message':
          'No classes on Monday for the school holiday. Enjoy your long weekend everyone!',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/pagasa.png',
      'accountName': 'Dost_pagasa',
      'message':
          'TROPICAL CYCLONE BULLETIN NR. 16 Super Typhoon #GoringPH (SAOLA) Issued at 5:00 PM, 27 August 2023 Valid for broadcast until the next bulletin at 11:00 PM today. GORING PERSISTS IN STRENGTH WHILE MOVING SOUTH SOUTHEASTWARD EAST NORTHEAST OF CASIGURAN, AURORA',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/cics.jpg',
      'accountName': 'College of Informatics and Computing Sciences - CICS',
      'message':
          'Due to the moderate and heavy rains brought by Tropical Depression Florita, and by recommendation of the Batangas City Mayor, Face-to-Face and Online Classes in ALL LEVELS of BatStateU Pablo Borbon and BatStateU Alangilan are hereby suspended today, August 24. Please observe safety precautions until the situation has normalized.',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/BSUSSC.png',
      'accountName': 'Supreme Student Council - BatStateU Alangilan Campus',
      'message':
          'Classes are suspended tomorrow due to typhoon warnings. Stay safe everyone!',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/cics.jpg',
      'accountName': 'College of Informatics and Computing Sciences - CICS',
      'message':
          'Class schedules will be adjusted due to ongoing repairs in the main building. Check the updated schedule on our website.',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/wpa.jpg',
      'accountName': 'Walang Pasok Advisory',
      'message':
          'Classes are suspended today due to heavy rainfall and flooding in the area. Stay dry and safe!',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/batspio.jpg',
      'accountName': 'Batangas PIO',
      'message':
          'Typhoon Signal Number 3 is raised in our area. Classes are suspended until further notice.',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/pagasa.png',
      'accountName': 'Dost_pagasa',
      'message':
          'Weather update: Typhoon approaching. Please monitor local news for announcements on class suspensions.',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
    },
    {
      'profilePicture': 'assets/BSUSSC.png',
      'accountName': 'Supreme Student Council - BatStateU Alangilan Campus',
      'message':
          'ANNOUNCEMENT: NO CLASSES Source: Official Gazette Pursuant to Proclamation No. 986 of the President, April 9, 2021 (Friday) was declared as a regular holiday to commemorate the Araw ng Kagitingan. #ZitoRedSpartans',
      'likes': 0,
      'dislikes': 0,
      'notifications': false,
      'liked': false,
      'disliked': false,
      'date': null,
      'expanded': false,
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
      if (announcements[index]['notifications']) {
        _showCustomToast(context, "Added to Notifications");
      } else {
        _showCustomToast(context, "Removed from Notifications");
      }
    });
  }

  void _toggleExpanded(int index) {
    setState(() {
      announcements[index]['expanded'] = !announcements[index]['expanded'];
    });
  }

  void _showCustomToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: MediaQuery.of(context).size.width * 0.2,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Future<void> _confirmBlockAccount(int index) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Block Account'),
          content: Text(
              'Are you sure you want to block ${announcements[index]['accountName']}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Block'),
            ),
          ],
        );
      },
    );

    // If confirmed is null, assign it to false
    if (confirmed == null) {
      confirmed = false;
    }

    if (confirmed) {
      setState(() {
        announcements.removeWhere((announcement) =>
            announcement['accountName'] == announcements[index]['accountName']);
      });
      _showCustomToast(context, "Account Blocked");
    }
  }

  void _handleMenuSelection(String value, int index) {
    setState(() {
      switch (value) {
        case 'Block Account':
          _confirmBlockAccount(index);
          break;
        case 'Snooze for 30 days':
          _showCustomToast(context, "Account Snoozed");
          // Implement snooze functionality (if needed)
          break;
        case 'Hide Post':
          setState(() {
            announcements.removeAt(index);
          });
          _showCustomToast(context, "Post Hidden");
          break;
      }
    });
  }

  String truncateText(String text, int maxChars) {
    if (text.length <= maxChars) {
      return text;
    } else {
      return text.substring(0, maxChars) + '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final isExpanded = announcements[index]['expanded'];
          final message = announcements[index]['message'];
          final truncatedMessage = truncateText(message, 100);

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage(announcements[index]['profilePicture']),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              announcements[index]['accountName'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    16, // Match font size with message text
                              ),
                              overflow: TextOverflow.visible,
                            ),
                            Text(
                              announcements[index]['date']
                                  .toString()
                                  .substring(0, 10),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) =>
                            _handleMenuSelection(value, index),
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'Block Account',
                              child: Row(
                                children: [
                                  Icon(Icons.block, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text('Block Account'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Snooze for 30 days',
                              child: Row(
                                children: [
                                  Icon(Icons.snooze, color: Colors.orange),
                                  SizedBox(width: 10),
                                  Text('Snooze for 30 days'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Hide Post',
                              child: Row(
                                children: [
                                  Icon(Icons.hide_source, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text('Hide Post'),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: isExpanded ? message : truncatedMessage,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 60, 60, 60),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                          ),
                        ),
                        if (!isExpanded && message.length > 100)
                          TextSpan(
                            text: ' Read more',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _toggleExpanded(index),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          announcements[index]['liked']
                              ? Icons.thumb_up
                              : Icons.thumb_up_alt_outlined,
                          color: announcements[index]['liked']
                              ? Colors.blue
                              : null,
                        ),
                        onPressed: () => _toggleLike(index),
                      ),
                      Text('${announcements[index]['likes']}'),
                      SizedBox(width: 16.0),
                      IconButton(
                        icon: Icon(
                          announcements[index]['disliked']
                              ? Icons.thumb_down
                              : Icons.thumb_down_alt_outlined,
                          color: announcements[index]['disliked']
                              ? Colors.red
                              : null,
                        ),
                        onPressed: () => _toggleDislike(index),
                      ),
                      Text('${announcements[index]['dislikes']}'),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          announcements[index]['notifications']
                              ? Icons.notifications_active
                              : Icons.notifications_none,
                          color: announcements[index]['notifications']
                              ? Colors.blue
                              : null,
                        ),
                        onPressed: () => _toggleNotification(index),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
