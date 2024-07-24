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
  List<DateTime> reminders = []; // New list for reminders

  DateTime currentDate = DateTime(2024, 8, 9);
  DateTime nextNoClassDay = DateTime(2024, 8, 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDatePickerAndAddDetails(context);
        },
        backgroundColor: Colors.red[100],
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 15),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double fontSize = constraints.maxWidth * 0.035;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                                .map((day) => Expanded(
                                      child: Center(
                                        child: Text(
                                          day,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red[800],
                                            fontSize: fontSize,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                      );
                    },
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
                      bool isReminder = reminders.contains(currentDay);
                      bool isCurrentDate = currentDay == currentDate;

                      IconData? getIcon() {
                        if (isHoliday) return Icons.event;
                        if (isWeatherDisturbance) return Icons.cloud;
                        if (isUserNoClassDay) return Icons.person;
                        if (isReminder) return Icons.event_note;
                        return null;
                      }

                      Color getBackgroundColor() {
                        if (isCurrentDate) return Colors.blue[100]!;
                        if (isHoliday ||
                            isWeatherDisturbance ||
                            isUserNoClassDay) {
                          return Colors.red[100]!;
                        }
                        if (isPartialNoClassDay) {
                          return Colors.yellow[100]!;
                        }
                        if (isReminder) {
                          return Colors.purple[100]!;
                        }
                        return Colors.white;
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          double iconSize = constraints.maxWidth * 0.25;
                          return GestureDetector(
                            onTap: () {
                              _showDayDetails(
                                  context,
                                  currentDay,
                                  isHoliday,
                                  isWeatherDisturbance,
                                  isUserNoClassDay,
                                  isPartialNoClassDay,
                                  isReminder);
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
                                    isPartialNoClassDay ||
                                    isReminder)
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
      bool isPartialNoClassDay,
      bool isReminder) {
    String reason = '';
    String holidayName = '';
    if (isHoliday) {
      reason = 'Holiday';
      holidayName =
          holidays.firstWhere((holiday) => holiday['date'] == day)['name'];
    } else if (isWeatherDisturbance) {
      reason = 'Weather Disturbance';
    } else if (isUserNoClassDay) {
      reason = 'Asynchronous Class';
    } else if (isPartialNoClassDay) {
      reason = 'Partial Class Cancellation';
    } else if (isReminder) {
      reason = 'Reminder';
    }

    TextEditingController noteController = TextEditingController(
      text: userNotes[day] ?? '',
    );
    bool noClassDay = isUserNoClassDay;
    bool partialNoClass = isPartialNoClassDay;
    bool reminder = isReminder;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editing Date ${day.day}/${day.month}/${day.year}'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (reason.isNotEmpty)
                  Text('$reason${isHoliday ? ' - $holidayName' : ''}'),
                TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: 'Add Note',
                  ),
                ),
                CheckboxListTile(
                  title: Text('Asynchronous Class'),
                  checkColor: Colors.white,
                  activeColor: Colors.red,
                  value: noClassDay,
                  onChanged: (newValue) {
                    setState(() {
                      noClassDay = newValue ?? false;
                      if (noClassDay) {
                        partialNoClass = false;
                        reminder = false;
                      }
                    });
                    Navigator.of(context).pop();
                    _showDayDetails(
                      context,
                      day,
                      isHoliday,
                      isWeatherDisturbance,
                      noClassDay,
                      partialNoClass,
                      reminder,
                    );
                  },
                ),
                CheckboxListTile(
                  title: Text('Partial Class Cancellation'),
                  checkColor: Colors.white,
                  activeColor: Colors.red,
                  value: partialNoClass,
                  onChanged: (newValue) {
                    setState(() {
                      partialNoClass = newValue ?? false;
                      if (partialNoClass) {
                        noClassDay = false;
                        reminder = false;
                      }
                    });
                    Navigator.of(context).pop();
                    _showDayDetails(
                      context,
                      day,
                      isHoliday,
                      isWeatherDisturbance,
                      noClassDay,
                      partialNoClass,
                      reminder,
                    );
                  },
                ),
                CheckboxListTile(
                  title: Text('Reminder'),
                  checkColor: Colors.white,
                  activeColor: Colors.red,
                  value: reminder,
                  onChanged: (newValue) {
                    setState(() {
                      reminder = newValue ?? false;
                      if (reminder) {
                        noClassDay = false;
                        partialNoClass = false;
                      }
                    });
                    Navigator.of(context).pop();
                    _showDayDetails(
                      context,
                      day,
                      isHoliday,
                      isWeatherDisturbance,
                      noClassDay,
                      partialNoClass,
                      reminder,
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50], foregroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  if (noteController.text.isNotEmpty) {
                    userNotes[day] = noteController.text;
                  } else {
                    userNotes.remove(day);
                  }
                  if (noClassDay) {
                    userNoClassDays.add(day);
                  } else {
                    userNoClassDays.remove(day);
                  }
                  if (partialNoClass) {
                    partialNoClassDays.add(day);
                  } else {
                    partialNoClassDays.remove(day);
                  }
                  if (reminder) {
                    reminders.add(day);
                  } else {
                    reminders.remove(day);
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
      _showDayDetails(context, selectedDate, false, false, false, false, false);
    });
  }
}
