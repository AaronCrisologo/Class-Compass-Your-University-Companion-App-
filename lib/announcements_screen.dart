import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AnnouncementsScreen extends StatefulWidget {
  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<Map<String, dynamic>> announcements = [];
  DateTime _fetchedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements(); // Fetch suspension announcements
    _fetchWeatherUpdates(); // Fetch weather updates
    _fetchVolcanoAnnouncements(); // Fetch volcano updates
    _fetchCampusAnnouncements(); // Fetch campus-specific announcements
  }

  // Fetch suspension announcements from the API
  Future<void> _fetchAnnouncements() async {
    final url =
        'http://localhost:3000/scrape/gma-suspensions'; // Update with your backend endpoint

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
              'image': 'assets/gma.png', // Change this if needed
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

  // Fetch volcano announcements from the API
  Future<void> _fetchVolcanoAnnouncements() async {
    final url =
        'http://localhost:3000/scrape/gma-volcano'; // Update with your backend endpoint

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
              'accountName': 'GMA News (Taal Volcano)',
              'image': 'assets/gma.png', // Change this if needed
            });
          });
        } else {
          print('Error: Invalid response structure. Expected key "message".');
        }
      } else {
        throw Exception('Failed to load volcano announcements');
      }
    } catch (error) {
      print('Error fetching volcano announcements: $error');
    }
  }

  // Fetch weather updates from the API
  Future<void> _fetchWeatherUpdates() async {
    final url =
        'http://localhost:3000/scrape/gma-weather'; // Update with your backend endpoint

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
              'accountName': 'GMA News (Weather Updates)',
              'image': 'assets/gma.png', // Change this if needed
            });
          });
        } else {
          print('Error: Invalid response structure. Expected key "message".');
        }
      } else {
        throw Exception('Failed to load weather updates');
      }
    } catch (error) {
      print('Error fetching weather updates: $error');
    }
  }

  // Fetch campus-specific announcements
  Future<void> _fetchCampusAnnouncements() async {
    final url = 'http://localhost:3000/get-announcements'; // New endpoint

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('announcements')) {
          final campusAnnouncements = data['announcements'];

          setState(() {
            for (var announcement in campusAnnouncements) {
              final message = announcement['message'] ?? 'No message';
              final formattedMessage = _formatMessage(message);

              announcements.add({
                'message': formattedMessage,
                'accountName': 'Admin Announcements (Campus)',
                'image':
                    'assets/school.png', // Adjust image based on your needs
              });
            }
          });
        } else {
          print(
              'Error: Invalid response structure. Expected key "announcements".');
        }
      } else {
        throw Exception('Failed to load campus announcements');
      }
    } catch (error) {
      print('Error fetching campus announcements: $error');
    }
  }

  // Helper function to format message text
  String _formatMessage(String message) {
    final regExp = RegExp(r'(\b\w+\s?\w*)\s*-\s*');
    final formattedMessage = message.replaceAllMapped(regExp, (match) {
      return '${match.group(1)}\n- ';
    });
    return formattedMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Announcements as of ${DateFormat('MMMM d, yyyy').format(_fetchedDate)}',
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
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(announcement['image']),
                      ),
                      SizedBox(width: 10),
                      Text(
                        announcement['accountName'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Text(
                      announcement['message'],
                      style: TextStyle(fontSize: 14),
                      maxLines: null,
                      softWrap: true,
                    ),
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
