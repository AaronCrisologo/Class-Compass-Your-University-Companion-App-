import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.red,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Aaron Angelo Crisologo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  double fontSize = constraints.maxWidth * 0.046;
                  fontSize =
                      fontSize > 18 ? 18 : fontSize; // Set max font size to 18
                  return Text(
                    'College of Information and Computing Science',
                    style: TextStyle(fontSize: fontSize),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              SizedBox(height: 5),
              LayoutBuilder(
                builder: (context, constraints) {
                  double fontSize = constraints.maxWidth * 0.046;
                  fontSize =
                      fontSize > 18 ? 18 : fontSize; // Set max font size to 18
                  return Text(
                    'Bachelor of Science Information Technology',
                    style: TextStyle(fontSize: fontSize),
                    textAlign: TextAlign.center,
                  );
                },
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
                subtitle: Text('21-08166@g.batstate-u.edu.ph'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Phone'),
                subtitle: Text('+123 456 7890'),
              ),
              ListTile(
                leading: Icon(Icons.location_city),
                title: Text('Address'),
                subtitle: Text('Banaybanay, Lipa City, Batangas'),
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
      ),
    );
  }
}
