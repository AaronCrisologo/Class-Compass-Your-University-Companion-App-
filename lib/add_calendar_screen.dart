import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCalendarScreen extends StatefulWidget {
  @override
  _AddCalendarScreenState createState() => _AddCalendarScreenState();
}

class _AddCalendarScreenState extends State<AddCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedCampus;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _campuses = [
    'All Campuses',
    'Pablo Borbon',
    'Alangilan',
    'Nasugbu',
    'Balayan',
    'Lemery',
    'Mabini',
    'Malvar',
    'Lipa',
    'Rosario',
    'San-Juan',
    'Lobo',
  ];

  String getFormattedDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  String getFormattedTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  void _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveAsynchronousDay() async {
    final String apiUrl = 'http://localhost:3000/calendar/admin-marked-days-with-notes';
    final Map<String, dynamic> payload = {
      'marked_date': _selectedDate.toIso8601String(),
      'campus': _selectedCampus,
      'note_text': _notesController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Asynchronous day saved successfully!')),
        );
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Error saving asynchronous day')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the server')),
      );
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Asynchronous Day',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Date:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(getFormattedDate(_selectedDate)),
              SizedBox(height: 16),
              Text(
                'Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(_notesController.text.isNotEmpty
                  ? _notesController.text
                  : 'No notes added'),
              SizedBox(height: 16),
              Text(
                'Campus:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(_selectedCampus ?? 'Not selected'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveAsynchronousDay();
              },
              child: Text('Save' , style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Date and Time
            Text(
              'Today\'s Date:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              getFormattedDate(DateTime.now()),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.red[800], fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Current Time:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              getFormattedTime(DateTime.now()),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.red[800], fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),

            // Date Picker
            Text(
              'Pick a Date:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.red),
                title: Text(
                  getFormattedDate(_selectedDate),
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.arrow_drop_down),
                onTap: () => _pickDate(context),
              ),
            ),
            SizedBox(height: 24),

            // Notes Text Area
            Text(
              'Add Notes:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _notesController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Type your notes here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Campus Dropdown
            Text(
              'Select Campus:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedCampus,
                  hint: Text('Choose a campus'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCampus = newValue;
                    });
                  },
                  items: _campuses.map((String campus) {
                    return DropdownMenuItem<String>(
                      value: campus,
                      child: Text(campus),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),

            // Save Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_selectedCampus == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a campus')),
                    );
                    return;
                  }
                  _showConfirmationDialog(context);
                },
                child: Text(
                  'Save Asynchronous Day',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
