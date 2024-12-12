import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile_screen.dart';
import 'resources.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> announcements = [];
  List<Map<String, dynamic>> nextDaySchedule = [];
  String nextMarkedDay = "";
  String nextHoliday = "";
  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
    _fetchNextEvents();
    fetchUserData();
    _fetchNextDaySchedule();
  }

  Future<void> _fetchAnnouncements() async {
    final url = 'https://ggbg0m6m-3000.asse.devtunnels.ms/scrape/gma-suspensions';

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

  Future<void> _fetchNextEvents() async {
    final url = 'https://ggbg0m6m-3000.asse.devtunnels.ms/calendar/next-events';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        setState(() {
          nextMarkedDay = data['nextMarkedDay'] != null
              ? "Next Marked Day: ${data['nextMarkedDay']['marked_date']} (${data['nextMarkedDay']['day_type']})"
              : "No marked day";
          nextHoliday = data['nextHoliday'] != null
              ? "Next Holiday: ${data['nextHoliday']['holiday_date']} (${data['nextHoliday']['holiday_name']})"
              : "No upcoming holiday";
        });
      } else {
        throw Exception('Failed to load next events');
      }
    } catch (error) {
      print('Error fetching next events: $error');
    }
  }

Future<void> _fetchNextDaySchedule() async {
  final url = 'https://ggbg0m6m-3000.asse.devtunnels.ms/get-next-day-schedule';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      
      setState(() {
        nextDaySchedule = data.map((schedule) => {
          'name': schedule['name'] ?? 'Unnamed Class',
          'instructor': schedule['instructor'] ?? 'Unknown Instructor',
          'startTime': schedule['starttime'] ?? '',
          'endTime': schedule['endtime'] ?? '',
          'color': schedule['color'] ?? 'Blue', // Default to 'Blue'
        }).toList();
      });
    } else {
      print('Failed to load next day schedule');
    }
  } catch (error) {
    print('Error fetching next day schedule: $error');
  }
}

  String _formatMessage(String message) {
    // Customize message
    return message;
  }

  // Function to fetch user data
  Future<void> fetchUserData() async {
    final response = await http.get(Uri.parse('https://ggbg0m6m-3000.asse.devtunnels.ms/get-user'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        firstName = data['firstname'];
        lastName = data['lastname'];
      });
    } else {
      print('Failed to load user data');
    }
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
                  'Welcome, $firstName $lastName',
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

                Text(
                  'Next Events',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Next Marked Day Card
                    _buildEventCard(
                      context,
                      title: 'Next Marked Day',
                      date: nextMarkedDay,
                      icon: Icons.event_note,
                      color: Colors.blueAccent,
                    ),
                    // Next Holiday Card
                    _buildEventCard(
                      context,
                      title: 'Next Holiday',
                      date: nextHoliday,
                      icon: Icons.card_giftcard,
                      color: Colors.greenAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                _buildNextDayScheduleSection(), // Add this line
                const SizedBox(height: 40),

                // Quick Links
                _buildSectionTitle('Quick Links'),
                _buildVerticalList(
                  context,
                  items: [
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

  Widget _buildNextDayScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Tomorrow\'s Schedule'),
        SizedBox(height: 10),
        nextDaySchedule.isNotEmpty
            ? Column(
                children: nextDaySchedule.map((schedule) {
                  return _buildScheduleCard(schedule);
                }).toList(),
              )
            : Center(
                child: Text(
                  'No classes scheduled for tomorrow',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
      ],
    );
  }

Widget _buildScheduleCard(Map<String, dynamic> schedule) {
  // Color mapping for common color names
  final colorMap = {
    'Red': Colors.red,
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Yellow': Colors.yellow,
    'Purple': Colors.purple,
    'Orange': Colors.orange,
  };

  // Get color, default to blue if not found
  Color cardColor = colorMap[schedule['color']] ?? Colors.blue;

  return Card(
    elevation: 4,
    margin: EdgeInsets.only(bottom: 10),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 60,
            color: cardColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Instructor: ${schedule['instructor']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${schedule['startTime']} - ${schedule['endTime']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildEventCard(
    BuildContext context, {
    required String title,
    required String date,
    required IconData icon,
    required Color color,
  }) {
    // Format the date to only show the day without other text
    String formattedDate = _formatDate(date);

    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {

    // Remove unwanted prefixes
    date = date.replaceAll("Next Marked Day: ", "").replaceAll("Next Holiday: ", "");

    // If the date is of type (no_class) or (reminder), replace it accordingly
    if (date.contains("(no_class)")) {
      return date.replaceAll("(no_class)", "(Asynchronous)");
    } else if (date.contains("(reminder)")) {
      return date.replaceAll("(reminder)", "(Reminder)");
    } else {
      return date; // Return the date as is if no special cases
    }
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
