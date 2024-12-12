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
        'https://ggbg0m6m-3000.asse.devtunnels.ms/scrape/gma-suspensions'; // Update with your backend endpoint

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
        'https://ggbg0m6m-3000.asse.devtunnels.ms/scrape/gma-volcano'; // Update with your backend endpoint

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
        'https://ggbg0m6m-3000.asse.devtunnels.ms/scrape/gma-weather'; // Update with your backend endpoint

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
  // Fetch campus-specific announcements
  Future<void> _fetchCampusAnnouncements() async {
    final url = 'https://ggbg0m6m-3000.asse.devtunnels.ms/get-announcements'; // New endpoint
    print('Fetching campus announcements...'); // Debug print

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Campus announcement response: $data'); // Debug print

        // Check if the response contains 'announcements' and it's a list
        if (data is Map<String, dynamic> && data.containsKey('announcements')) {
          final campusAnnouncements = data['announcements'];

          if (campusAnnouncements is List) {
            if (mounted) {
              // Ensure that the widget is still mounted
              setState(() {
                announcements.clear(); // Clear previous announcements

                // Sort announcements by timestamp (if available) in descending order
                campusAnnouncements.sort((a, b) {
                  final timestampA =
                      a['timestamp'] ?? 0; // Use 0 if no timestamp is provided
                  final timestampB = b['timestamp'] ?? 0;
                  return timestampB.compareTo(timestampA); // Sort descending
                });

                int limit = 3; // Limit to 3 latest announcements
                int count = 0; // Initialize counter

                for (var announcement in campusAnnouncements) {
                  if (count >= limit) break; // Stop after 3 announcements
                  if (announcement is Map<String, dynamic>) {
                    final title = announcement['title'] ??
                        'No title'; // Safe access to 'title'
                    final body = announcement['body'] ??
                        'No message'; // Safe access to 'body'
                    final formattedMessage = _formatMessage(body);
                    final campus = announcement['campus'] ?? 'No title';

                    // Add the title and message (body) to the announcements list
                    announcements.add({
                      'title': title, // Include the title in the announcement
                      'message': formattedMessage,
                      'accountName':
                          '${campus} Announcement', // Adjust as needed
                      'image': 'assets/bsu logo.png', // Adjust image as needed
                    });

                    count++; // Increment the counter
                  }
                }
                print('Campus announcements added'); // Debug print
              });
            }
          } else {
            print('Error: Announcements data is not a list');
          }
        } else {
          print(
              'Error: Invalid response structure. Expected key "announcements".');
        }
      } else if (response.statusCode == 404) {
        print('No announcements found for the current campus');
      } else {
        print(
            'Error: Failed to load campus announcements with status: ${response.statusCode}');
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
