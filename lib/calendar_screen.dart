import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<Map<String, dynamic>> holidays = [
    {'date': DateTime(2024, 8, 21), 'name': 'Ninoy Aquino Day'},
    {'date': DateTime(2024, 8, 26), 'name': 'National Heroes Day'},
  ];

  List<DateTime> weatherDisturbances = [
    DateTime(2024, 8, 15), // Random weather disturbance example
  ];

  Map<DateTime, String> userNotes = {};
  List<DateTime> userNoClassDays = [];
  List<DateTime> partialNoClassDays = []; // New list for partial no class days

  DateTime currentDate = DateTime(2024, 8, 9);
  DateTime nextNoClassDay = DateTime(2024, 8, 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics:
                    NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                shrinkWrap: true, // Take up only the necessary space
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.0,
                ),
                itemCount: daysInMonth(DateTime(2024, 8)) +
                    4, // Offset for starting on Thursday
                itemBuilder: (context, index) {
                  DateTime currentDay;
                  if (index < 4) {
                    currentDay = DateTime(2024, 7, 28 + index);
                  } else {
                    currentDay = DateTime(2024, 8, index - 3);
                  }
                  bool isHoliday =
                      holidays.any((holiday) => holiday['date'] == currentDay);
                  bool isWeatherDisturbance =
                      weatherDisturbances.contains(currentDay);
                  bool isUserNoClassDay = userNoClassDays.contains(currentDay);
                  bool isPartialNoClassDay =
                      partialNoClassDays.contains(currentDay);
                  bool isCurrentDate = currentDay == currentDate;

                  IconData? getIcon() {
                    if (isHoliday) return Icons.event;
                    if (isWeatherDisturbance) return Icons.cloud;
                    if (isUserNoClassDay) return Icons.person;
                    return null;
                  }

                  Color getBackgroundColor() {
                    if (isCurrentDate) return Colors.lightBlue[100]!;
                    if (isHoliday || isWeatherDisturbance || isUserNoClassDay) {
                      return Colors.red[100]!;
                    }
                    if (isPartialNoClassDay) {
                      return Colors.yellow[100]!;
                    }
                    return Colors.white;
                  }

                  return GestureDetector(
                    onTap: () {
                      _showDayDetails(
                          context,
                          currentDay,
                          isHoliday,
                          isWeatherDisturbance,
                          isUserNoClassDay,
                          isPartialNoClassDay);
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: getBackgroundColor(),
                          ),
                          child: Center(
                            child: Text(
                              index < 4 ? '' : '${currentDay.day}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        if (isHoliday ||
                            isWeatherDisturbance ||
                            isUserNoClassDay ||
                            isPartialNoClassDay)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (getIcon() != null)
                                  Icon(
                                    getIcon(),
                                    color: Colors.red,
                                    size: 18.0,
                                  ),
                                if (isPartialNoClassDay)
                                  Text(
                                    '*',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 24.0),
                                  ),
                                if (isHoliday ||
                                    isWeatherDisturbance ||
                                    isUserNoClassDay)
                                  Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 24.0,
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Current Date: ${currentDate.day}/${currentDate.month}/${currentDate.year}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Next No Class Day: ${nextNoClassDay.day}/${nextNoClassDay.month}/${nextNoClassDay.year}',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  void _showDayDetails(
      BuildContext context,
      DateTime day,
      bool isHoliday,
      bool isWeatherDisturbance,
      bool isUserNoClassDay,
      bool isPartialNoClassDay) {
    String reason = '';
    String holidayName = '';
    if (isHoliday) {
      reason = 'Holiday';
      holidayName =
          holidays.firstWhere((holiday) => holiday['date'] == day)['name'];
    } else if (isWeatherDisturbance) {
      reason = 'Weather Disturbance';
    } else if (isUserNoClassDay) {
      reason = 'No Class (User Defined)';
    } else if (isPartialNoClassDay) {
      reason = 'Partial Class Cancellation';
    }

    TextEditingController noteController = TextEditingController(
      text: userNotes[day] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Details for ${day.day}/${day.month}/${day.year}'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (reason.isNotEmpty)
                  Text(
                      'Reason: $reason${holidayName.isNotEmpty ? ' - $holidayName' : ''}'),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(labelText: 'Add a note'),
                  maxLines: 5, // Increase height for better note-taking
                ),
                CheckboxListTile(
                  title: Text('Mark as no class'),
                  value: isUserNoClassDay,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        userNoClassDays.add(day);
                        partialNoClassDays.remove(day);
                      } else {
                        userNoClassDays.remove(day);
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Mark as partial no class'),
                  value: isPartialNoClassDay,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        partialNoClassDays.add(day);
                        userNoClassDays.remove(day);
                      } else {
                        partialNoClassDays.remove(day);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  userNotes[day] = noteController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
