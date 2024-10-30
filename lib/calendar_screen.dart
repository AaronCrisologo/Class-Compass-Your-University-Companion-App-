import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

extension DateTimeFormatting on DateTime {
  String toShortDateString() {
    return "${this.year}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}";
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Map<String, dynamic>> holidays = [];
  List<DateTime> weatherDisturbances = []; // Replace with API call for weather
  Map<DateTime, String> userNotes = {};
  List<DateTime> userNoClassDays = [];
  List<DateTime> partialNoClassDays = [];
  List<DateTime> reminders = [];
  DateTime currentDate = DateTime.now();
  DateTime nextNoClassDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchCurrentTime();
    await fetchHolidays();
    await fetchUserNotes();
    await fetchMarkedDays();
  }

  Future<void> fetchCurrentTime() async {
    final response = await http.get(Uri.parse('http://localhost:3000/calendar/time'));
    if (response.statusCode == 200) {
      setState(() {
        currentDate = DateTime.parse(json.decode(response.body)['datetime']);
      });
    }
  }

  Future<void> fetchHolidays() async {
    final response = await http.get(Uri.parse('http://localhost:3000/calendar/holidays'));
    if (response.statusCode == 200) {
      final List<dynamic> holidaysData = json.decode(response.body);
      setState(() {
        holidays = holidaysData.map((holiday) {
          return {
            'date': DateTime.parse(holiday['holiday_date']),
            'name': holiday['holiday_name']
          };
        }).toList();
      });
    }
  }

  Future<void> fetchUserNotes() async {
    final response = await http.get(Uri.parse('http://localhost:3000/calendar/notes'));
    if (response.statusCode == 200) {
      final List<dynamic> notesData = json.decode(response.body);
      setState(() {
        userNotes = {
          for (var note in notesData)
            DateTime.parse(note['note_date']): note['note_text']
        };
      });
    }
  }

  Future<void> fetchMarkedDays() async {
    final response = await http.get(Uri.parse('http://localhost:3000/calendar/marked-days'));
    if (response.statusCode == 200) {
      final List<dynamic> daysData = json.decode(response.body);
      setState(() {
        userNoClassDays = daysData
            .where((day) => day['day_type'] == 'no_class')
            .map((day) => DateTime.parse(day['marked_date']))
            .toList();
        partialNoClassDays = daysData
            .where((day) => day['day_type'] == 'partial_no_class')
            .map((day) => DateTime.parse(day['marked_date']))
            .toList();
        reminders = daysData
            .where((day) => day['day_type'] == 'reminder')
            .map((day) => DateTime.parse(day['marked_date']))
            .toList();
      });
    }
  }

  Future<void> addNoteAndMarkedDay(DateTime day, String note, String dayType) async {
    await http.post(
      Uri.parse('http://localhost:3000/calendar/notes'),
      body: json.encode({'note_date': day.toIso8601String(), 'note_text': note}),
      headers: {'Content-Type': 'application/json'},
    );

    await http.post(
      Uri.parse('http://localhost:3000/calendar/marked-days'),
      body: json.encode({'marked_date': day.toIso8601String(), 'day_type': dayType}),
      headers: {'Content-Type': 'application/json'},
    );

    await fetchUserNotes();
    await fetchMarkedDays();
  }

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
                        children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
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
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: daysInMonth(currentDate) + 4,
                    itemBuilder: (context, index) {
                      DateTime currentDay;
                      if (index < 4) {
                        currentDay = DateTime(currentDate.year, currentDate.month - 1, 28 + index);
                      } else {
                        currentDay = DateTime(currentDate.year, currentDate.month, index - 3);
                      }
                      bool isHoliday = holidays.any((holiday) => holiday['date'] == currentDay);
                      bool isWeatherDisturbance = weatherDisturbances.contains(currentDay);
                      bool isUserNoClassDay = userNoClassDays.contains(currentDay);
                      bool isPartialNoClassDay = partialNoClassDays.contains(currentDay);
                      bool isReminder = reminders.contains(currentDay);
                      bool isCurrentDate = currentDay == currentDate;

                      return buildCalendarCell(
                        context,
                        currentDay,
                        isHoliday,
                        isWeatherDisturbance,
                        isUserNoClassDay,
                        isPartialNoClassDay,
                        isReminder,
                        isCurrentDate,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCalendarCell(
      BuildContext context,
      DateTime currentDay,
      bool isHoliday,
      bool isWeatherDisturbance,
      bool isUserNoClassDay,
      bool isPartialNoClassDay,
      bool isReminder,
      bool isCurrentDate) {
    IconData? getIcon() {
      if (isHoliday) return Icons.event;
      if (isWeatherDisturbance) return Icons.cloud;
      if (isUserNoClassDay) return Icons.person;
      if (isReminder) return Icons.event_note;
      return null;
    }

    Color getBackgroundColor() {
      if (isCurrentDate) return Colors.blue[100]!;
      if (isHoliday || isWeatherDisturbance || isUserNoClassDay) {
        return Colors.red[100]!;
      }
      if (isPartialNoClassDay) return Colors.yellow[100]!;
      if (isReminder) return Colors.purple[100]!;
      return Colors.white;
    }

    return GestureDetector(
      onTap: () {
        _showDayDetails(context, currentDay, isHoliday, isWeatherDisturbance, isUserNoClassDay, isPartialNoClassDay, isReminder);
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
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${currentDay.day}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (getIcon() != null)
            Positioned(
              top: 4,
              right: 4,
              child: Icon(
                getIcon(),
                color: Colors.red,
                size: 16.0,
              ),
            ),
        ],
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Details for ${day.toLocal().toShortDateString()}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isHoliday) Text("This day is a holiday!"),
              if (isWeatherDisturbance) Text("There is a weather disturbance."),
              if (isUserNoClassDay) Text("No classes on this day."),
              if (isPartialNoClassDay) Text("Partial class cancellation."),
              if (isReminder) Text("Reminder scheduled for this day."),
              Text("Notes: ${userNotes[day] ?? 'No notes for this day.'}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDatePickerAndAddDetails(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate != null) {
        _showAddNoteDialog(context, pickedDate);
      }
    });
  }

  void _showAddNoteDialog(BuildContext context, DateTime day) {
    final noteController = TextEditingController();
    String? selectedType;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Note for ${day.toLocal().toShortDateString()}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteController,
                decoration: InputDecoration(hintText: 'Enter note'),
              ),
              DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem(value: 'no_class', child: Text('No Class Day')),
                  DropdownMenuItem(value: 'partial_no_class', child: Text('Partial No Class Day')),
                  DropdownMenuItem(value: 'reminder', child: Text('Reminder')),
                ],
                onChanged: (value) => selectedType = value,
                decoration: InputDecoration(hintText: 'Select Day Type'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                addNoteAndMarkedDay(day, noteController.text, selectedType!);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
