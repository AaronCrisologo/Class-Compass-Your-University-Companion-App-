import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variables to hold user data
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
  String course = '';
  String section = '';
  bool isLoading = true;
  String errorMessage = '';

  // Function to fetch user data from the server
  Future<void> fetchUserData() async {
    final response = await http.get(
      Uri.parse(
          'https://ggbg0m6m-3000.asse.devtunnels.ms/get-user'), // Replace with your actual URL
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        // Combine firstname and lastname into full name
        name = '${data['firstname']} ${data['lastname']}';
        email = data['email'] ?? 'No Email';
        phone = data['phone'] ?? 'No Phone';
        address = data['address'] ?? 'No Address';
        course = data['course'] ?? 'No Course';
        section = data['section'] ?? 'No Section';
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = 'Failed to load user data: ${response.statusCode}';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Header with name, course, and section
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$course - $section',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 20),

                    // Profile Details in Cards
                    _buildProfileDetailCard(Icons.email, 'Email', email),
                    _buildProfileDetailCard(Icons.phone, 'Phone', phone),
                    _buildProfileDetailCard(
                        Icons.location_city, 'Address', address),

                    SizedBox(height: 20),

                    // Elevated Button for going back
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        backgroundColor: Colors.red, // Sleek red color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),

                    // Display error message if needed
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  // Function to build each profile detail in a card-style layout
  Widget _buildProfileDetailCard(IconData icon, String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Icon(
          icon,
          color: Colors.red,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
