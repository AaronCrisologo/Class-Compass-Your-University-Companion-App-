import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile_screen.dart';
import 'calendar_screen.dart';
import 'resources.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> announcements = [];

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    final url = 'http://localhost:3000/scrape/gma-suspensions';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('message')) {
          final message = data['message'];
          final formattedMessage = _formatMessage(message);

          setState(() {
            announcements.add({
              'message': formattedMessage,
              'accountName': 'GMA News (Suspensions)',
              'image': 'assets/gma.png',
            });
          });
        } else {
          print('Error: Invalid response structure. Expected key "message".');
        }
      } else {
        throw Exception('Failed to load suspensions');
      }
    } catch (error) {
      print('Error fetching announcements: $error');
    }
  }

  String _formatMessage(String message) {
    // Customize message formatting if needed
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text(
                  'Welcome to Class Compass',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                SizedBox(height: 20),
                // Latest Announcements
                Text(
                  'Latest Announcements',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                announcements.isNotEmpty
                    ? _buildAnnouncementCard(
                        announcements[0]['message']!,
                        announcements[0]['accountName']!,
                        announcements[0]['image']!,
                      )
                    : Center(child: CircularProgressIndicator()),
                SizedBox(height: 20),
                // Quick Links
                _buildSectionTitle('Quick Links'),
                _buildVerticalList(
                  context,
                  items: [
                    _buildQuickLinkCard(
                      context,
                      icon: Icons.calendar_today,
                      title: 'Academic Calendar',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarScreen()),
                        );
                      },
                    ),
                    _buildQuickLinkCard(
                      context,
                      icon: Icons.my_library_books,
                      title: 'School Resources',
                      onTap: () {
                        Navigator.push(
                          context,
                          _createRoute(ResourceScreen()),
                        );
                      },
                    ),
                    _buildQuickLinkCard(
                      context,
                      icon: Icons.info,
                      title: 'User Information',
                      onTap: () {
                        Navigator.push(
                          context,
                          _createRoute(ProfileScreen()),
                        );
                      },
                    ),
                    _buildQuickLinkCard(
                      context,
                      icon: Icons.cloud,
                      title: 'Weather Alerts',
                      onTap: () async {
                        const url =
                            'https://www.accuweather.com/en/ph/batangas-city/262266/weather-forecast/262266';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(
      String announcement, String userName, String userImage) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(userImage),
                ),
                SizedBox(width: 10),
                Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              announcement,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildVerticalList(BuildContext context,
      {required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: item,
            ),
          )
          .toList(),
    );
  }

  Widget _buildQuickLinkCard(BuildContext context,
      {required IconData icon,
      required String title,
      required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  size: 40,
                  color: Colors.red[700],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
