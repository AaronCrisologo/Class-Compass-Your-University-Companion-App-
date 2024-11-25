import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScheduleScreen(),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> hours = [
    '7:00 AM',
    '7:30 AM',
    '8:00 AM',
    '8:30 AM',
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '8:00 PM',
    '8:30 PM',
    '9:00 PM',
    '9:30 PM'
  ];

  List<Map<String, dynamic>> schedule = [];

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  // Fetch schedule data from the backend
  Future<void> _fetchSchedule() async {
    print('Fetching schedule from API...');
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/get-schedule'));
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');
        final List<dynamic> data = json.decode(response.body);
        print('Decoded Data: $data');

        setState(() {
          schedule = List<Map<String, dynamic>>.from(data);
        });
        print('Schedule updated successfully.');
      } else {
        print('Failed to load schedule, status code: ${response.statusCode}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to load schedule')));
      }
    } catch (e) {
      print('Error during schedule fetch: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching schedule')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weekly Schedule"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(color: Colors.black, width: 1),
                columnWidths: {0: FixedColumnWidth(80)},
                children: [
                  TableRow(
                    children: [
                      SizedBox(),
                      ...List.generate(
                        7,
                        (index) => Center(
                          child: Text(
                            days[index],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    hours.length,
                    (hourIndex) {
                      return TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              hours[hourIndex],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...List.generate(
                            7,
                            (dayIndex) {
                              final classesForCell = schedule.where((s) {
                                final startHour =
                                    _parseTimeTo24HourFormat(s['startTime']);
                                final endHour =
                                    _parseTimeTo24HourFormat(s['endTime']);
                                return s['day'] == days[dayIndex] &&
                                    startHour <= hourIndex + 7 &&
                                    endHour > hourIndex + 7;
                              }).toList();

                              return Container(
                                padding: EdgeInsets.all(8.0),
                                height: 50,
                                color: classesForCell.isNotEmpty
                                    ? Color(int.parse(
                                        "0xFF${classesForCell[0]['color']}"))
                                    : Colors.grey[200],
                                child: classesForCell.isNotEmpty
                                    ? Text(
                                        '${classesForCell[0]['name']}\n${classesForCell[0]['instructor']}',
                                        style: TextStyle(fontSize: 10),
                                        textAlign: TextAlign.center,
                                      )
                                    : null,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showAddScheduleDialog(context),
                child: Text('Add Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _parseTimeTo24HourFormat(String time) {
    final timeParts = time.split(' ');
    final timeComponents = timeParts[0].split(':');
    int hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    if (timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (timeParts[1] == 'AM' && hour == 12) {
      hour = 0;
    }
    return hour * 60 + minute; // return time in minutes
  }

  void _showAddScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ScheduleForm(),
        );
      },
    );
  }
}

class ScheduleForm extends StatefulWidget {
  @override
  _ScheduleFormState createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  final List<String> daysOfWeek = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];
  final List<String> hourValues = [
    '7:00 AM',
    '7:30 AM',
    '8:00 AM',
    '8:30 AM',
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '8:00 PM',
    '8:30 PM',
    '9:00 PM',
    '9:30 PM'
  ];

  String? selectedDay = 'Mon';
  String? selectedColor = 'FF5733';
  String? selectedStartTime = '9:00 AM';
  String? selectedEndTime = '10:00 AM';

  Future<void> _submitSchedule() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final instructor = _instructorController.text;
      final startTime = selectedStartTime;
      final endTime = selectedEndTime;
      final day = selectedDay;
      final color = selectedColor;

      if (name.isEmpty ||
          instructor.isEmpty ||
          startTime == null ||
          endTime == null ||
          day == null ||
          color == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please fill all fields')));
        return;
      }

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/schedule'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'instructor': instructor,
          'startTime': startTime,
          'endTime': endTime,
          'day': day,
          'color': color,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Schedule added successfully')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add schedule')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Class Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a class name' : null,
            ),
            TextFormField(
              controller: _instructorController,
              decoration: InputDecoration(labelText: 'Instructor Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter instructor name' : null,
            ),
            DropdownButtonFormField<String>(
              value: selectedDay,
              decoration: InputDecoration(labelText: 'Select Day'),
              onChanged: (newValue) => setState(() => selectedDay = newValue),
              items: daysOfWeek
                  .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                  .toList(),
            ),
            DropdownButtonFormField<String>(
              value: selectedStartTime,
              decoration: InputDecoration(labelText: 'Start Time'),
              onChanged: (newValue) =>
                  setState(() => selectedStartTime = newValue),
              items: hourValues
                  .map((hour) =>
                      DropdownMenuItem(value: hour, child: Text(hour)))
                  .toList(),
            ),
            DropdownButtonFormField<String>(
              value: selectedEndTime,
              decoration: InputDecoration(labelText: 'End Time'),
              onChanged: (newValue) =>
                  setState(() => selectedEndTime = newValue),
              items: hourValues
                  .map((hour) =>
                      DropdownMenuItem(value: hour, child: Text(hour)))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: _submitSchedule,
              child: Text('Add Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
