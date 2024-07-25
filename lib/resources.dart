import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resources',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildSectionTitle('Important Links'),
            buildHyperlink(Icons.calendar_today, 'School Calendar',
                'https://batstateu.edu.ph/academic-calendar/2023-2024/'),
            buildHyperlink(
                Icons.calendar_view_day,
                'Non-working Holiday Calendar',
                'https://www.timeanddate.com/holidays/philippines/2024'),
            buildHyperlink(FontAwesomeIcons.globe, 'School Website',
                'https://batstateu.edu.ph/'),
            buildHyperlink(FontAwesomeIcons.facebook, 'School Facebook Page',
                'https://www.facebook.com/BatStateUTheNEU'),
            buildHyperlink(FontAwesomeIcons.twitter, 'School Twitter Page',
                'https://twitter.com/BatStateUTheNEU'),
            buildHyperlink(
                Icons.web, 'Student Portal', 'https://dione.batstate-u.edu.ph/student/#/'),
            SizedBox(height: 30),
            buildSectionTitle('Contact Information'),
            buildContactInfo(Icons.email, 'Email', 'tao.alangilan@g.batstate-u.edu.ph'),
            buildContactInfo(Icons.phone, 'Telephone', '425-0139'),
            buildContactInfo(Icons.phone, 'Mobile', '+63 907 847 8442'),
            SizedBox(height: 30),
            buildSectionTitle('Emergency Hotlines'),
            buildContactInfo(FontAwesomeIcons.phoneSquare, 'Mayors Action Center', '723-1511'),
            buildContactInfo(FontAwesomeIcons.phoneSquare, 'PNP Batangas City', '723-2030'),
            buildContactInfo(
                FontAwesomeIcons.phoneSquare, 'BFP Batangas City', '425-7163'),
            buildContactInfo(FontAwesomeIcons.phoneSquare, 'Batangas Medical Center', '723-0911'),
            buildContactInfo(FontAwesomeIcons.phoneSquare, 'MERALCO ', '16211'),
            buildContactInfo(FontAwesomeIcons.phoneSquare, 'PrimeWater Batangas City', '980-6928'),
            buildContactInfo(
                FontAwesomeIcons.phoneSquare, 'City Disaster Risk Reduction and Management Office', '702-3902'),
            SizedBox(height: 30),
            buildSectionTitle('Additional Resources'),
            buildHyperlink(FontAwesomeIcons.book, 'Library Catalog',
                'https://library.batstate-u.edu.ph/#/main/home'),
            buildHyperlink(FontAwesomeIcons.laptop, 'Online Courses',
                'https://batstateu.edu.ph/global/courses/'),
            buildHyperlink(Icons.library_books, 'Curriculum (BSIT)',
                'https://batstateu.edu.ph/wp-content/uploads/2024/06/NEU-BSIT-Curriculum-18-19.pdf#toolbar=0'), 
            buildHyperlink(FontAwesomeIcons.infoCircle, 'Help Desk',
                'https://batstateu.edu.ph/contact-us/'),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.red[700],
        ),
      ),
    );
  }

  Widget buildHyperlink(IconData icon, String text, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(icon, color: Colors.red[700]),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContactInfo(IconData icon, String type, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.red[700]),
          SizedBox(width: 10),
          Text(
            '$type: ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            info,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
