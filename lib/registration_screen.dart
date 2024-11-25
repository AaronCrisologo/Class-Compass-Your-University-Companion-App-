import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the LoginScreen
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _courseController = TextEditingController();
  final _passwordController = TextEditingController(); // Password controller
  final _firstnameController = TextEditingController(); // First name controller
  final _lastnameController = TextEditingController(); // Last name controller

  String? _selectedSection; // Selected value for the dropdown
  final List<String> _sections = [
    'Pablo Borbon Campus',
    'Alangilan Campus',
    'Arasof-Nasugbu Campus',
    'Balayan Campus',
    'Lemery Campus',
    'Mabini Campus',
    'JPLPC-Malvar Campus',
    'Lipa Campus',
    'Rosario Campus',
    'San Juan Campus',
    'Lobo Campus',
  ];
  // Example sections

  // Registration Function
  void _register() async {
    String email = _emailController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;
    String course = _courseController.text;
    String password = _passwordController.text;
    String firstname = _firstnameController.text;
    String lastname = _lastnameController.text;
    String? section = _selectedSection;

    // Check if all fields are filled
    if (email.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        course.isEmpty ||
        password.isEmpty ||
        firstname.isEmpty ||
        lastname.isEmpty ||
        section == null) {
      _showErrorDialog('All fields are required');
      return;
    }

    var url = Uri.parse('http://localhost:3000/register'); // Adjust as needed

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
          'course': course,
          'section': section, // Use selected section
          'firstName': firstname, // Match the backend field name
          'lastName': lastname, // Match the backend field name
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['message'] == 'User registered successfully') {
          _showSuccessDialog();
        } else {
          _showErrorDialog('Registration failed. Please try again.');
        }
      } else {
        var data = jsonDecode(response.body);
        _showErrorDialog(data['message'] ??
            'Registration failed. Please check your details.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again later.');
    }
  }

  // Show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Successfully registered!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen()), // Navigate to login screen
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Colors.red[700], // Match the theme color
      ),
      backgroundColor: Colors.red[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.school,
                    size: 100,
                    color: Colors.red[700],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: constraints.maxWidth * 0.8,
                    child: Text(
                      'Register to Class Compass',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          _buildTextField('First Name', _firstnameController,
                              Icons.person, false),
                          _buildTextField('Last Name', _lastnameController,
                              Icons.person, false),
                          _buildTextField(
                              'Email', _emailController, Icons.email, false),
                          _buildTextField('Password', _passwordController,
                              Icons.lock, true),
                          _buildTextField(
                              'Phone', _phoneController, Icons.phone, false),
                          _buildTextField('Address', _addressController,
                              Icons.location_on, false),
                          _buildTextField(
                              'Course', _courseController, Icons.book, false),
                          _buildSectionDropdown(),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red[700],
                              backgroundColor: Colors.red[300],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      IconData icon, bool obscureText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.red[700]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Campus',
            style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedSection,
          items: _sections
              .map((section) =>
                  DropdownMenuItem(value: section, child: Text(section)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedSection = value;
            });
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.class_, color: Colors.red[700]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
