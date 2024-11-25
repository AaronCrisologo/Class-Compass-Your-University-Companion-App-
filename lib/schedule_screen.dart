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
    '7:00 AM', '7:30 AM',
    '8:00 AM', '8:30 AM',
    '9:00 AM', '9:30 AM',
    '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM',
    '12:00 PM', '12:30 PM',
    '1:00 PM', '1:30 PM',
    '2:00 PM', '2:30 PM',
    '3:00 PM', '3:30 PM',
    '4:00 PM', '4:30 PM',
    '5:00 PM', '5:30 PM',
    '6:00 PM', '6:30 PM',
    '7:00 PM'
  ];

  List<dynamic> scheduleData = [];
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  String getFullTimeString(String hour) {
    if (hour == '-') return '';
    return hour;
  }

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
    final Map<String, Color> colors = {
      'red': Color(0xFFFFCACA),
      'green': Color(0xFFD7FFD9),
      'blue': Color(0xFFCAE9FF),
      'yellow': Color(0xFFFFF4CA),
      'purple': Color(0xFFE9CAFF),
      'orange': Color(0xFFFFE5CA),
    };
    return colors[colorName.toLowerCase()] ?? Color(0xFFF5F5F5);
  }

  // Improved time parsing function
  DateTime parseTimeString(String timeStr) {
    // Split the time string into components
    final parts = timeStr.split(' ');
    final timeParts = parts[0].split(':');
    final period = parts[1];
    
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    
    // Convert to 24-hour format
    if (period == 'PM' && hours != 12) {
      hours += 12;
    } else if (period == 'AM' && hours == 12) {
      hours = 0;
    }
    
    return DateTime(2024, 1, 1, hours, minutes);
  }

  // Improved time comparison function
  bool isTimeInRange(String currentTimeStr, String startTimeStr, String endTimeStr) {
    final currentTime = parseTimeString(currentTimeStr);
    final startTime = parseTimeString(startTimeStr);
    final endTime = parseTimeString(endTimeStr);
    
    return (currentTime.isAtSameMomentAs(startTime) || currentTime.isAfter(startTime)) && 
           currentTime.isBefore(endTime);
  }

  // Updated schedule cell builder
  Set<String> displayedNamesAndTimes = {};

Widget _buildScheduleCell(String timeSlot, String day) {
  List<dynamic> cellSchedules = scheduleData.where((schedule) {
    return schedule['day'] == day &&
          isTimeInRange(timeSlot, schedule['starttime'], schedule['endtime']);
  }).toList();

  bool isOccupied = cellSchedules.isNotEmpty;

  if (isOccupied) {
    String name = cellSchedules[0]['name'];
    String timeRange = '${cellSchedules[0]['starttime']} - ${cellSchedules[0]['endtime']}';
    String uniqueKey = '$name|$timeRange';

    if (displayedNamesAndTimes.contains(uniqueKey)) {
      name = '';
      timeRange = '';
    } else {
      displayedNamesAndTimes.add(uniqueKey);
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Schedule Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cellSchedules.map((schedule) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Subject Name: ${schedule['name']}\n(${schedule['starttime']} - ${schedule['endtime']})\nInstructor: ${schedule['instructor']}\nColor: ${schedule['color']}',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Open edit screen or dialog
                    Navigator.of(context).pop();
                    _editSchedule(cellSchedules[0]); // Call edit function
                  },
                  child: Text('Edit'),
                ),
                TextButton(
                  onPressed: () {
                    // Confirm and delete schedule
                    _deleteSchedule(cellSchedules[0]); // Call delete function
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          color: getColorFromString(cellSchedules[0]['color']),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (name.isNotEmpty)
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              if (timeRange.isNotEmpty)
                Text(
                  timeRange,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  } else {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
      ),
    );
  }
}

// Function to handle editing
void _editSchedule(dynamic schedule) {
  final _formKey = GlobalKey<FormState>();

  // Provide default empty string values and use null-aware operators
  final TextEditingController nameController =
      TextEditingController(text: schedule['name']?.toString() ?? '');
  final TextEditingController instructorController =
      TextEditingController(text: schedule['instructor']?.toString() ?? '');
  final TextEditingController startTimeController =
      TextEditingController(text: schedule['starttime']?.toString() ?? '');
  final TextEditingController endTimeController =
      TextEditingController(text: schedule['endtime']?.toString() ?? '');
  final TextEditingController dayController =
      TextEditingController(text: schedule['day']?.toString() ?? '');

  String? selectedColor = schedule['color']?.toString();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Schedule'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Subject Name'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter subject name'
                          : null,
                ),
                TextFormField(
                  controller: instructorController,
                  decoration: InputDecoration(labelText: 'Instructor'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter instructor name'
                          : null,
                ),
                TextFormField(
                  controller: startTimeController,
                  decoration: InputDecoration(labelText: 'Start Time'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter start time'
                          : null,
                ),
                TextFormField(
                  controller: endTimeController,
                  decoration: InputDecoration(labelText: 'End Time'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter end time'
                          : null,
                ),
                TextFormField(
                  controller: dayController,
                  decoration: InputDecoration(labelText: 'Day'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter day'
                          : null,
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
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Collect data from controllers
                final updatedSchedule = {
                  'id': schedule['id'],
                  'name': nameController.text.trim(),
                  'instructor': instructorController.text.trim(),
                  'starttime': startTimeController.text.trim(),
                  'endtime': endTimeController.text.trim(),
                  'day': dayController.text.trim(),
                  'color': selectedColor ?? schedule['color']?.toString() ?? '',
                };

                try {
                  // Send updated data to backend
                  final response = await http.post(
                    Uri.parse('http://localhost:3000/updateSchedule'),
                    body: json.encode(updatedSchedule),
                    headers: {'Content-Type': 'application/json'},
                  );

                  if (response.statusCode == 200) {
                    // Update local data and trigger UI rebuild
                    setState(() {
                      int index = scheduleData.indexWhere((s) => s['id'] == schedule['id']);
                      if (index != -1) {
                        scheduleData[index] = updatedSchedule;
                      }
                    });
                    print('Schedule updated successfully');
                    Navigator.of(context).pop();
                  } else {
                    print('Failed to update schedule: ${response.body}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update schedule')),
                    );
                  }
                } catch (error) {
                  print('Error updating schedule: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating schedule')),
                  );
                }
              }
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

// Function to handle deleting
void _deleteSchedule(dynamic schedule) async {
  // Backend delete logic
  try {
    final response = await http.post(
      Uri.parse('http://localhost:3000/deleteSchedule'),
      body: json.encode({'id': schedule['id']}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Update local data after deletion
      setState(() {
        scheduleData.removeWhere((s) => s['id'] == schedule['id']);
      });
      print('Schedule deleted successfully');
    } else {
      print('Failed to delete schedule: ${response.body}');
    }
  } catch (error) {
    print('Error deleting schedule: $error');
  }
}

void _showAddScheduleDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        "Weekly Schedule",
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        controller: _verticalController,
        child: Column(
          children: [
            SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                            color: Colors.grey[50],
                          ),
                        ),
                        ...days.map((day) => Container(
                          width: 120,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                            color: Colors.blue.withOpacity(0.1),
                          ),
                          child: Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        )),
                      ],
                    ),
                    // Time Slots
                    ...hours.map((hour) => Row(
                      children: [
                        Container(
                          width: 80,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                            color: Colors.grey[50],
                          ),
                          child: Text(
                            hour,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        ...days.map((day) => _buildScheduleCell(hour, day)),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _showAddScheduleDialog(context),
      backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white),
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
              decoration: InputDecoration(
                labelText: 'Schedule Name',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
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
