import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For parsing JSON
import 'package:intl/intl.dart'; // For formatting dates

class AnnouncementsScreen extends StatefulWidget {
  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  // The list of announcements fetched from a server
  List<Map<String, dynamic>> announcements = [];
  DateTime _fetchedDate = DateTime.now(); // Default to current date

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  // Fetch the list of announcements from the API
  Future<void> _fetchAnnouncements() async {
    final url = 'http://localhost:3000/scrape/gma-suspensions';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decode the response body into a Map
        final data = json.decode(response.body);

        // Ensure the response has the expected structure (with 'message' key)
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          final message = data['message'];

          // Format the message to insert line breaks
          final formattedMessage = _formatMessage(message);

          // Add the formatted message to the list
          setState(() {
            announcements = [
              {
                'message': formattedMessage,
                'accountName': 'GMA News',
                'expanded': false,
                'image': 'assets/gma.png', // Add the image path here
              }
            ];
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

  // Function to format the message and insert line breaks where necessary
  String _formatMessage(String message) {
    // Split the message into separate provinces and suspension details
    final formattedMessage = message.replaceAllMapped(
        RegExp(r'(province - .+?)(?= (?:,|$))'),
        (match) => '${match.group(0)}\n');

    return formattedMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Class Suspension Announcements as of ${DateFormat('MMMM d, yyyy').format(_fetchedDate)}',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final announcement = announcements[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Profile picture
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(announcement['image']),
                      ),
                      SizedBox(width: 10),
                      // Account name
                      Text(
                        announcement['accountName'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Display the formatted message
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: announcement['message'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          announcement['expanded']
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            announcement['expanded'] =
                                !announcement['expanded'];
                          });
                        },
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
