import 'profile_screen.dart';
import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'resources.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  // Sample data for upcoming classes
  final List<Map<String, String>> upcomingClasses = [
    {
      'name': 'Application Development',
      'dateTime': 'August 10, 10:00 AM',
      'location': 'Software Lab 2, CICS Building'
    },
    {
      'name': 'Integrative Programming',
      'dateTime': 'August 10, 2:00 PM',
      'location': 'Room 104, CICS Building'
    },
    {
      'name': 'System Quality Assurance',
      'dateTime': 'August 12, 7:00 AM',
      'location': 'CISCO Lab, CICS Building'
    },
    {
      'name': 'Human-computer interaction',
      'dateTime': 'August 12, 10:00 AM',
      'location': 'Room 106, CICS Building'
    },
    {
      'name': 'Social Issues and Professional Practice',
      'dateTime': 'August 14, 4:00 PM',
      'location': 'Room 106, CICS Building'
    },
  ];

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
                // Upcoming Classes
                Text(
                  'Upcoming Classes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: upcomingClasses.length, // Number of classes
                    itemBuilder: (context, index) {
                      final classInfo = upcomingClasses[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.only(right: 16),
                        child: Container(
                          width: 250,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                classInfo['name']!, // Class name
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                classInfo['dateTime']!, // Date & time
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                classInfo['location']!, // Location
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                // New Notifications Indicator
                Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: Colors.red[700],
                    ),
                    SizedBox(width: 10),
                    Text(
                      'New Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    // Replace this with actual logic to check for new notifications
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
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
                _buildAnnouncementCard(
                    'ACADEMIC BREAK: NO CLASSES on August 2-6, 2024. In light of the ongoing challenge caused by the Typhoon, the University Student Council stands with you in providing assistance and support to students and their families who were severely affected by the typhoon in order to assist them in recovering completely from the chaos.',
                    'CABEIHM Student Council',
                    'assets/cabeihm.jpg'),
                _buildAnnouncementCard(
                    '#WalangPasokAdvisory: Malacañang declares Monday, Jul 17, a regular holiday in observance of Eidl Adha. Proclamation No. 579 signed by Executive Secretary Lucas Bersamin was released yesterday, June 5, 2024.',
                    'Walang Pasok Advisory',
                    'assets/wpa.jpg'),
                _buildAnnouncementCard(
                    'Upon the recommendation of the Provincial Disaster Risk Reduction and Management Office, and in view of the continuing inclement weather due to the effects of TS Florita, classes in private and public schools, from kindergarten to senior high school, are suspended tomorrow, 24 August 2022, in the whole Province of Batangas. Stay safe Batangueños!',
                    'Batangas PIO',
                    'assets/batspio.jpg'),
                SizedBox(height: 20),
                // Events and Holidays
                Text(
                  'Events and Holidays',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                _buildEventCard('Tech Workshop', 'July 28, 2:00 PM - 5:00 PM'),
                _buildEventCard('Ninoy Aquino Day', 'August 21'),
                _buildEventCard('National Heroes Day', 'August 26'),
                _buildEventCard('School Intramurals', 'August 5 - 7:00 AM'),
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
                  backgroundImage: NetworkImage(userImage),
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
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(String event, String dateTime) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              dateTime,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
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
