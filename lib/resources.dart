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
                'https://schoolcalendar.example.com'),
            buildHyperlink(
                Icons.calendar_view_day,
                'Non-working Holiday Calendar',
                'https://holidaycalendar.example.com'),
            buildHyperlink(FontAwesomeIcons.globe, 'School Website',
                'https://schoolwebsite.example.com'),
            buildHyperlink(FontAwesomeIcons.facebook, 'School Facebook Page',
                'https://facebook.com/schoolpage'),
            buildHyperlink(FontAwesomeIcons.twitter, 'School Twitter Page',
                'https://twitter.com/schoolpage'),
            buildHyperlink(
                Icons.web, 'School Portal', 'https://schoolportal.example.com'),
            SizedBox(height: 30),
            buildSectionTitle('Contact Information'),
            buildContactInfo(Icons.email, 'Email', 'contact@school.edu'),
            buildContactInfo(Icons.phone, 'Telephone', '+1 234 567 890'),
            buildContactInfo(Icons.phone, 'Mobile', '+1 987 654 321'),
            SizedBox(height: 30),
            buildSectionTitle('Emergency Hotlines'),
            buildContactInfo(FontAwesomeIcons.phoneSquare, 'Police', '911'),
            buildContactInfo(
                FontAwesomeIcons.phoneSquare, 'Fire Department', '912'),
            buildContactInfo(FontAwesomeIcons.phoneSquare, 'Hospital', '913'),
            buildContactInfo(
                FontAwesomeIcons.phoneSquare, 'Emergency Hotline', '914'),
            SizedBox(height: 30),
            buildSectionTitle('Additional Resources'),
            buildHyperlink(FontAwesomeIcons.book, 'Library Catalog',
                'https://librarycatalog.example.com'),
            buildHyperlink(FontAwesomeIcons.laptop, 'Online Courses',
                'https://onlinecourses.example.com'),
            buildHyperlink(FontAwesomeIcons.infoCircle, 'Help Center',
                'https://helpcenter.example.com'),
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
