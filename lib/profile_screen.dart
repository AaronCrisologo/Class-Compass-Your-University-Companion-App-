import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.red,
              child: CircleAvatar(
                radius: 48,
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'User Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Department: CICS',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              'Course: Bachelor of Science Information Technology',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              'Section: IT-3301',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text('user@example.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
              subtitle: Text('+123 456 7890'),
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text('Address'),
              subtitle: Text('123 Main St, Hometown, Country'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
