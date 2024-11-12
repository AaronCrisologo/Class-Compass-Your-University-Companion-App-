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
    _fetchAnnouncements();
    _fetchWeatherUpdates();
    _fetchVolcanoAnnouncements();
  }

  // Fetch suspension announcements from the API
  Future<void> _fetchAnnouncements() async {
    final url = 'http://localhost:3000/scrape/gma-suspensions';

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
              'image': 'assets/gma.png',
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

  Future<void> _fetchVolcanoAnnouncements() async {
    final url = 'http://localhost:3000/scrape/gma-volcano';

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
              'image': 'assets/gma.png',
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

  // Fetch weather updates from the API
  Future<void> _fetchWeatherUpdates() async {
    final url = 'http://localhost:3000/scrape/gma-weather';

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
              'image': 'assets/gma.png'
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

  // Fetch date from API

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
