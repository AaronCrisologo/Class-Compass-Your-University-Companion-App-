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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              title: Text(
                'Schedule Details', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.red[700]
                )
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cellSchedules.map((schedule) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${schedule['name']}', 
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold
                            )
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Time: ${schedule['starttime']} - ${schedule['endtime']}', 
                            style: TextStyle(color: Colors.grey[700])
                          ),
                          Text(
                            'Instructor: ${schedule['instructor']}', 
                            style: TextStyle(color: Colors.grey[700])
                          ),
                          Row(
                            children: [
                              Text(
                                'Color: ${schedule['color']}', 
                                style: TextStyle(color: Colors.grey[700])
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: getColorFromString(schedule['color']),
                                  shape: BoxShape.circle
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red[700]),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _editSchedule(cellSchedules[0]);
                  },
                  child: Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    _deleteSchedule(cellSchedules[0]);
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
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

  String? selectedName = schedule['name']?.toString();
  String? selectedInstructor = schedule['instructor']?.toString();
  String? selectedStartTime = schedule['starttime']?.toString();
  String? selectedEndTime = schedule['endtime']?.toString();
  String? selectedDay = schedule['day']?.toString();
  String? selectedColor = schedule['color']?.toString();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        title: Text(
          'Edit Schedule', 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.red[700]
          )
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: selectedName,
                  onChanged: (value) => selectedName = value,
                  decoration: InputDecoration(
                    labelText: 'Subject Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter subject name'
                          : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: selectedInstructor,
                  onChanged: (value) => selectedInstructor = value,
                  decoration: InputDecoration(
                    labelText: 'Instructor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter instructor name'
                          : null,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedStartTime,
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  items: hours.map((hour) => 
                    DropdownMenuItem(value: hour, child: Text(hour))
                  ).toList(),
                  onChanged: (value) => selectedStartTime = value,
                  validator: (value) => 
                    value == null ? 'Select start time' : null,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedEndTime,
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  items: hours.map((hour) => 
                    DropdownMenuItem(value: hour, child: Text(hour))
                  ).toList(),
                  onChanged: (value) => selectedEndTime = value,
                  validator: (value) => 
                    value == null ? 'Select end time' : null,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedDay,
                  decoration: InputDecoration(
                    labelText: 'Day',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  items: days.map((day) => 
                    DropdownMenuItem(value: day, child: Text(day))
                  ).toList(),
                  onChanged: (value) => selectedDay = value,
                  validator: (value) => 
                    value == null ? 'Select day' : null,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedColor,
                  decoration: InputDecoration(
                    labelText: 'Color',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  items: ['Red', 'Green', 'Blue', 'Yellow', 'Purple', 'Orange']
                    .map((color) => DropdownMenuItem(
                      value: color,
                      child: Text(color),
                    )).toList(),
                  onChanged: (value) => selectedColor = value,
                  validator: (value) => 
                    value == null ? 'Select color' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final updatedSchedule = {
                  'id': schedule['id'],
                  'name': selectedName,
                  'instructor': selectedInstructor,
                  'starttime': selectedStartTime,
                  'endtime': selectedEndTime,
                  'day': selectedDay,
                  'color': selectedColor,
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
            child: Text('Save', style: TextStyle(color: Colors.white)),
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
          borderRadius: BorderRadius.circular(20), // More pronounced rounded corners
        ),
        elevation: 16, // Increased elevation for more depth
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.red.withOpacity(0.05)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Increased padding
            child: ScheduleForm(
              onScheduleAdded: () {
                fetchScheduleData();
                Navigator.pop(context);
              },
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // Optional: add a subtle background or border if needed
              ),
            ),
          ),
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
        "Your Weekly Schedule",
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
                            color: Colors.red.withOpacity(0.1),
                          ),
                          child: Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
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
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => _showAddScheduleDialog(context),
      backgroundColor: Colors.red[600],
      icon: Icon(Icons.add_circle_outline, color: Colors.white),
      label: Text(
        'Add Schedule', 
        style: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold
        )
      ),
      elevation: 6,
    ),
  );
}
}

class ScheduleForm extends StatefulWidget {
  final VoidCallback onScheduleAdded;
  final BoxDecoration? decoration;

  ScheduleForm({
    required this.onScheduleAdded, 
    this.decoration,
  });

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
    return Container(
      decoration: widget.decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New Schedule',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.red[800],
            ),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Improved input fields with consistent styling
                _buildTextField(
                  controller: _nameController,
                  labelText: 'Schedule Name',
                  icon: Icons.subject,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  controller: _instructorController,
                  labelText: 'Instructor',
                  icon: Icons.person,
                ),
                SizedBox(height: 10),
                // Dropdowns with improved styling
                _buildDropdown(
                  value: selectedStartTime,
                  items: hourValues,
                  labelText: 'Start Time',
                  icon: Icons.access_time,
                  onChanged: (newValue) => setState(() {
                    selectedStartTime = newValue;
                  }),
                ),
                SizedBox(height: 10),
                _buildDropdown(
                  value: selectedEndTime,
                  items: hourValues,
                  labelText: 'End Time',
                  icon: Icons.access_time,
                  onChanged: (newValue) => setState(() {
                    selectedEndTime = newValue;
                  }),
                ),
                SizedBox(height: 10),
                _buildDropdown(
                  value: selectedDay,
                  items: daysOfWeek,
                  labelText: 'Day of Week',
                  icon: Icons.calendar_today,
                  onChanged: (newValue) => setState(() {
                    selectedDay = newValue;
                  }),
                ),
                SizedBox(height: 10),
                _buildDropdown(
                  value: selectedColor,
                  items: ['Red', 'Green', 'Blue', 'Yellow', 'Purple', 'Orange'],
                  labelText: 'Color',
                  icon: Icons.color_lens,
                  onChanged: (newValue) => setState(() {
                    selectedColor = newValue;
                  }),
                ),
                SizedBox(height: 20),
                // Improved submit button
                ElevatedButton(
                  onPressed: _submitSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Add Schedule',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create consistent text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.red[600]),
        filled: true,
        fillColor: Colors.red.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please enter $labelText' : null,
    );
  }

  // Helper method to create consistent dropdowns
  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String labelText,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.red[600]),
        filled: true,
        fillColor: Colors.red.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      validator: (value) =>
          value == null ? 'Please select $labelText' : null,
    );
  }
}