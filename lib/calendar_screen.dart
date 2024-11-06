import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<Map<String, String>>> events = {};
  DateTime focusedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchHolidays();
    await fetchWeatherDisturbances();
    await fetchCombinedNotesAndMarkedDays();
    setState(() {});
  }

  Future<void> fetchHolidays() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/calendar/holidays'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        for (var holiday in data) {
          DateTime date = DateTime.parse(holiday['holiday_date']).toLocal();
          String name = holiday['holiday_name'];

          events[date] = events[date] ?? [];
          events[date]!.add({"type": "Holiday", "description": name});
        }
      }
    } catch (e) {
      print("Error fetching holidays: $e");
    }
  }

  Future<void> fetchWeatherDisturbances() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/calendar/weather-disturbances'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        for (var disturbance in data) {
          DateTime date = DateTime.parse(disturbance['date']).toLocal();
          events[date] = events[date] ?? [];
          events[date]!.add({"type": "Weather Alert", "description": disturbance['description']});
        }
      }
    } catch (e) {
      print("Error fetching weather disturbances: $e");
    }
  }

  Future<void> fetchCombinedNotesAndMarkedDays() async {
    try {
      final markedDaysResponse = await http.get(Uri.parse('http://localhost:3000/calendar/marked-days'));
      if (markedDaysResponse.statusCode == 200) {
        List<dynamic> markedDaysData = jsonDecode(markedDaysResponse.body);
        for (var markedDay in markedDaysData) {
          DateTime date = DateTime.parse(markedDay['marked_date']).toLocal();
          String type = markedDay['day_type'];
          events[date] = events[date] ?? [];
          events[date]!.add({"type": type, "description": "Marked Day"});
        }
      }

      final notesResponse = await http.get(Uri.parse('http://localhost:3000/calendar/notes'));
      if (notesResponse.statusCode == 200) {
        List<dynamic> notesData = jsonDecode(notesResponse.body);
        for (var note in notesData) {
          DateTime date = DateTime.parse(note['note_date']).toLocal();
          events[date] = events[date] ?? [];
          events[date]!.add({"type": "Note", "description": note['note_text']});
        }
      }
    } catch (e) {
      print("Error fetching combined notes and marked days: $e");
    }
  }

Future<void> _addCustomMarkedDay() async {
  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: focusedDate,
    firstDate: DateTime.now(),
    lastDate: DateTime.utc(2030, 12, 31),
  );

  if (selectedDate != null) {
    if (events[selectedDate] != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Marked Day Already Exists'),
          content: Text('Please delete the current mark before adding a new one.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    String? dayType = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Day Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('No Class'),
                onTap: () => Navigator.of(context).pop('no_class'),
              ),
              ListTile(
                title: Text('Reminder'),
                onTap: () => Navigator.of(context).pop('reminder'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel button to close dialog
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (dayType != null) {
      String? userInputNote = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: Text('Enter Note'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Enter your note here"),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(controller.text),
                child: Text('Submit'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );

      if (userInputNote != null && userInputNote.isNotEmpty) {
        await http.post(
          Uri.parse('http://localhost:3000/calendar/marked-days'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({'marked_date': selectedDate.toIso8601String(), 'day_type': dayType}),
        );

        await http.post(
          Uri.parse('http://localhost:3000/calendar/notes'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({'note_date': selectedDate.toIso8601String(), 'note_text': userInputNote}),
        );

        events[selectedDate] = events[selectedDate] ?? [];
        events[selectedDate]!.add({"type": dayType, "description": userInputNote});
        setState(() {});
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDate,
            calendarFormat: CalendarFormat.month,
            eventLoader: (date) {
              return events[DateTime(date.year, date.month, date.day)]?.map((e) => e["description"] ?? "").toList() ?? [];
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.tealAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.orange, 
                shape: BoxShape.circle,
              ),
              markerSize: 5.0,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                focusedDate = focusedDay;
              });
              if (events[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] != null) {
                showEventDetails(context, selectedDay);
              }
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, eventsList) {
                final eventTypes = events[DateTime(date.year, date.month, date.day)]?.map((e) => e['type']).toSet() ?? {};

                Color markerColor;
                if (eventTypes.contains("Holiday")) {
                  markerColor = Colors.blue;
                } else if (eventTypes.contains("no_class")) {
                  markerColor = Colors.grey;
                } else if (eventTypes.contains("reminder")) {
                  markerColor = Colors.orange;
                } else {
                  markerColor = Colors.teal;
                }

                return eventsList.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          color: markerColor,
                          shape: BoxShape.circle,
                        ),
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      )
                    : null;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomMarkedDay,
        tooltip: 'Add Custom Marked Day',
        child: Icon(Icons.add),
      ),
    );
  }

void showEventDetails(BuildContext context, DateTime date) {
  final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
  final eventDetails = events[normalizedDate] ?? [];
  bool isHoliday = eventDetails.any((event) => event["type"] == "Holiday");
  
// Filter out items with "Marked Day" as the description
  final filteredEvents = eventDetails.where((event) => event["description"] != "Marked Day").toList();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Events on ${DateFormat.yMMMd().format(date)}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: filteredEvents.map((event) {
          return ListTile(
            title: Text(event["type"] ?? ""),
            subtitle: Text(event["description"] ?? ""),
          );
        }).toList(),
      ),
      actions: [
        if (!isHoliday) // Only show delete option if it's not a holiday
          TextButton(
            child: Text("Delete"),
            onPressed: () async {
              await deleteDate(normalizedDate);
              Navigator.of(context).pop();
            },
          ),
        TextButton(
          child: Text("Close"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

Future<void> deleteDate(DateTime date) async {
  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
  
  try {
    // Delete user notes
    final noteResponse = await http.delete(Uri.parse('http://localhost:3000/calendar/notes/$formattedDate'));
    if (noteResponse.statusCode != 200) {
      print("Failed to delete note: ${noteResponse.body}");
    }

    // Delete custom marked day
    final markedDayResponse = await http.delete(Uri.parse('http://localhost:3000/calendar/marked-days/$formattedDate'));
    if (markedDayResponse.statusCode != 200) {
      print("Failed to delete marked day: ${markedDayResponse.body}");
    }

    // Remove events from local state
    setState(() {
      events.remove(date);
    });
  } catch (e) {
    print("Error deleting date: $e");
  }
}
}
