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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDatePickerAndAddDetails(context);
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[800],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  GridView.builder(
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
                      bool isHoliday = holidays
                          .any((holiday) => holiday['date'] == currentDay);
                      bool isWeatherDisturbance =
                          weatherDisturbances.contains(currentDay);
                      bool isUserNoClassDay =
                          userNoClassDays.contains(currentDay);
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
                        if (isCurrentDate) return Colors.red[100]!;
                        if (isHoliday ||
                            isWeatherDisturbance ||
                            isUserNoClassDay) {
                          return Colors.red[100]!;
                        }
                        if (isPartialNoClassDay) {
                          return Colors.yellow[100]!;
                        }
                        return Colors.white;
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          double iconSize = constraints.maxWidth * 0.3;
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
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      index < 4 ? '' : '${currentDay.day}',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
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
                                            size: iconSize,
                                          ),
                                        if (isPartialNoClassDay)
                                          Text(
                                            '*',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: iconSize),
                                          ),
                                        if (isHoliday ||
                                            isWeatherDisturbance ||
                                            isUserNoClassDay)
                                          Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: iconSize,
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Current Date: ${currentDate.day}/${currentDate.month}/${currentDate.year}',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Next Asynchronous Date: ${nextNoClassDay.day}/${nextNoClassDay.month}/${nextNoClassDay.year}',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.04,
                            fontStyle: FontStyle.italic,
                            color: Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
      reason = 'Asynchronous Class (User Defined)';
    } else if (isPartialNoClassDay) {
      reason = 'Partial Class Cancellation';
    }

    TextEditingController noteController = TextEditingController(
      text: userNotes[day] ?? '',
    );
    bool noClassDay = isUserNoClassDay;
    bool partialNoClass = isPartialNoClassDay;

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
                  title: Text('Mark as asynchronous class'),
                  value: noClassDay,
                  onChanged: (bool? value) {
                    setState(() {
                      noClassDay = value ?? false;
                      if (noClassDay) {
                        userNoClassDays.add(day);
                        partialNoClassDays.remove(day);
                      } else {
                        userNoClassDays.remove(day);
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Mark as partial asynchronous'),
                  value: partialNoClass,
                  onChanged: (bool? value) {
                    setState(() {
                      partialNoClass = value ?? false;
                      if (partialNoClass) {
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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (noteController.text.isNotEmpty) {
                    userNotes[day] = noteController.text;
                  } else {
                    userNotes.remove(day);
                  }
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

  void _showDatePickerAndAddDetails(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate != null) {
        selectedDate = pickedDate;
        _showDayDetails(context, selectedDate, false, false, false, false);
      }
    });
  }
}
