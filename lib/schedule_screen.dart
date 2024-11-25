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
    '7 AM', '8 AM', '9 AM', '10 AM', '11 AM', '12 PM',
    '1 PM', '2 PM', '3 PM', '4 PM', '5 PM', '6 PM',
    '7 PM', '8 PM', '9 PM'
  ];
  
  List<dynamic> scheduleData = [];

  @override
  void initState() {
    super.initState();
    fetchScheduleData();
  }

  Future<void> fetchScheduleData() async {
    print('Fetching schedule from API...');
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/get-schedule'));
      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');
        print('Schedule updated successfully.');
        setState(() {
          scheduleData = json.decode(response.body);
        });
      } else {
        print('Failed to load schedule, status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load schedule data'))
        );
      }
    } catch (e) {
      print('Error during schedule fetch: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to server'))
      );
    }
  }

  Color getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red': return Colors.red[100]!;
      case 'green': return Colors.green[100]!;
      case 'blue': return Colors.blue[100]!;
      case 'yellow': return Colors.yellow[100]!;
      case 'purple': return Colors.purple[100]!;
      case 'orange': return Colors.orange[100]!;
      default: return Colors.grey[200]!;
    }
  }

  DateTime parseTimeString(String timeStr) {
    // Remove any spaces between time and AM/PM
    timeStr = timeStr.replaceAll(' ', '');
    
    // Split the time string into components
    RegExp regex = RegExp(r'(\d{1,2}):?(\d{2})?([APM]{2})');
    Match? match = regex.firstMatch(timeStr);
    
    if (match == null) {
      throw FormatException('Invalid time format: $timeStr');
    }
    
    // Extract hours, minutes, and period
    int hours = int.parse(match.group(1)!);
    int minutes = match.group(2) != null ? int.parse(match.group(2)!) : 0;
    String period = match.group(3)!;
    
    // Adjust hours for PM
    if (period == 'PM' && hours != 12) {
      hours += 12;
    } else if (period == 'AM' && hours == 12) {
      hours = 0;
    }
    
    // Create DateTime object
    return DateTime(2024, 1, 1, hours, minutes);
  }

  bool isTimeInRange(String timeStr, String startTime, String endTime) {
    try {
      // Parse all times using the new parser
      final time = parseTimeString(timeStr);
      final start = parseTimeString(startTime);
      final end = parseTimeString(endTime);
      
      return (time.isAtSameMomentAs(start) || time.isAfter(start)) && 
             (time.isBefore(end) || time.isAtSameMomentAs(end));
    } catch (e) {
      print('Error parsing time: $e');
      return false;
    }
  }

  Widget _buildScheduleCell(String hour, String day) {
    List<dynamic> cellSchedules = scheduleData.where((schedule) {
      return schedule['day'] == day && 
             isTimeInRange(hour, schedule['starttime'], schedule['endtime']);
    }).toList();

    if (cellSchedules.isEmpty) {
      return Container(
        padding: EdgeInsets.all(8.0),
        height: 50,
        color: Colors.grey[200],
      );
    }

    return Container(
      padding: EdgeInsets.all(4.0),
      height: 50,
      color: getColorFromString(cellSchedules[0]['color']),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cellSchedules[0]['name'],
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            cellSchedules[0]['instructor'],
            style: TextStyle(fontSize: 8),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: ScheduleForm(onScheduleAdded: () {
              fetchScheduleData();
              Navigator.pop(context);
            }),
          ),
        );
      },
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weekly Schedule"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  border: TableBorder.all(color: Colors.black, width: 1),
                  columnWidths: {
                    0: FixedColumnWidth(80),
                    for (int i = 1; i <= 7; i++) i: FixedColumnWidth(120),
                  },
                  children: [
                    TableRow(
                      children: [
                        SizedBox(height: 50),
                        ...List.generate(
                          7,
                          (index) => Container(
                            height: 50,
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                days[index],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
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
                              height: 50,
                              child: Text(
                                hours[hourIndex],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ...List.generate(
                              7,
                              (dayIndex) => _buildScheduleCell(
                                hours[hourIndex],
                                days[dayIndex],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
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
}

class ScheduleForm extends StatefulWidget {
  final VoidCallback onScheduleAdded;

  ScheduleForm({required this.onScheduleAdded});

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
    '9:30 PM',
  ];
  String? selectedDay;
  String? selectedColor;
  String? selectedStartTime;
  String? selectedEndTime;

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

      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/schedule'),
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
          widget.onScheduleAdded();
        } else if (response.statusCode == 400) {
          final responseBody = json.decode(response.body);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(responseBody['message'])));
        } else if (response.statusCode == 409) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Overlap in Scheduling')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to add schedule')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error connecting to server')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Schedule Name'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter schedule name' : null,
            ),
            TextFormField(
              controller: _instructorController,
              decoration: InputDecoration(labelText: 'Instructor'),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter instructor name'
                  : null,
            ),
            DropdownButtonFormField<String>(
              value: selectedStartTime,
              onChanged: (newValue) => setState(() {
                selectedStartTime = newValue;
              }),
              items: hourValues
                  .map((hour) => DropdownMenuItem(
                        value: hour,
                        child: Text(hour),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Start Time'),
              validator: (value) =>
                  value == null ? 'Please select a start time' : null,
            ),
            DropdownButtonFormField<String>(
              value: selectedEndTime,
              onChanged: (newValue) => setState(() {
                selectedEndTime = newValue;
              }),
              items: hourValues
                  .map((hour) => DropdownMenuItem(
                        value: hour,
                        child: Text(hour),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'End Time'),
              validator: (value) =>
                  value == null ? 'Please select an end time' : null,
            ),
            DropdownButtonFormField<String>(
              value: selectedDay,
              onChanged: (newValue) => setState(() {
                selectedDay = newValue;
              }),
              items: daysOfWeek
                  .map((day) => DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Day of the Week'),
              validator: (value) =>
                  value == null ? 'Please select a day' : null,
            ),
            DropdownButtonFormField<String>(
              value: selectedColor,
              onChanged: (newValue) => setState(() {
                selectedColor = newValue;
              }),
              items: ['Red', 'Green', 'Blue', 'Yellow', 'Purple', 'Orange']
                  .map((color) => DropdownMenuItem(
                        value: color,
                        child: Text(color),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Color'),
              validator: (value) =>
                  value == null ? 'Please select a color' : null,
            ),
            SizedBox(height: 20),
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
