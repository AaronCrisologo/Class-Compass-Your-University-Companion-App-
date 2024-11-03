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
  Map<DateTime, List<String>> events = {};
  DateTime focusedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchHolidays();
    await fetchWeatherDisturbances();
    await fetchCombinedNotesAndMarkedDays(); // Combined function call
    setState(() {});
  }

  Future<void> fetchHolidays() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/calendar/holidays'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        data.forEach((holiday) {
          DateTime date = DateTime.parse(holiday['holiday_date']).toLocal();
          String name = holiday['holiday_name'];

          events[DateTime(date.year, date.month, date.day)] = events[DateTime(date.year, date.month, date.day)] ?? [];
          events[DateTime(date.year, date.month, date.day)]!.add("Holiday: $name");
          print("Holiday added: $name on $date (local)");
        });
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
        data.forEach((disturbance) {
          DateTime date = DateTime.parse(disturbance['date']).toLocal();

          events[DateTime(date.year, date.month, date.day)] = events[DateTime(date.year, date.month, date.day)] ?? [];
          events[DateTime(date.year, date.month, date.day)]!.add("Weather Alert: ${disturbance['description']}");
          print("Weather alert added on $date (local)");
        });
      }
    } catch (e) {
      print("Error fetching weather disturbances: $e");
    }
  }

  Future<void> fetchCombinedNotesAndMarkedDays() async {
    try {
      // Fetch marked days
      final markedDaysResponse = await http.get(Uri.parse('http://localhost:3000/calendar/marked-days'));
      if (markedDaysResponse.statusCode == 200) {
        List<dynamic> markedDaysData = jsonDecode(markedDaysResponse.body);
        markedDaysData.forEach((markedDay) {
          DateTime date = DateTime.parse(markedDay['marked_date']).toLocal();
          String type = markedDay['day_type'];

          events[DateTime(date.year, date.month, date.day)] = events[DateTime(date.year, date.month, date.day)] ?? [];
          print("Marked Day added on $date (local): $type");
        });
      }

      // Fetch user notes
      final notesResponse = await http.get(Uri.parse('http://localhost:3000/calendar/notes'));
      if (notesResponse.statusCode == 200) {
        List<dynamic> notesData = jsonDecode(notesResponse.body);
        notesData.forEach((note) {
          DateTime date = DateTime.parse(note['note_date']).toLocal();

          events[DateTime(date.year, date.month, date.day)]!.add("Note: ${note['note_text']}");
          print("Note added on $date (local)");
        });
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
                  onPressed: () {
                    Navigator.of(context).pop(controller.text); // Pass the entered note
                  },
                  child: Text('Submit'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(null); // Cancel input
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );

        if (userInputNote != null && userInputNote.isNotEmpty) {
          // Send marked day to the backend
          await http.post(
            Uri.parse('http://localhost:3000/calendar/marked-days'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'marked_date': selectedDate.toIso8601String(),
              'day_type': dayType,
            }),
          );

          // Send user input note to the backend
          await http.post(
            Uri.parse('http://localhost:3000/calendar/notes'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'note_date': selectedDate.toIso8601String(),
              'note_text': userInputNote,
            }),
          );

          // Update local events map
          events[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)] =
              events[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)] ?? [];
          events[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)]!.add("Note: $userInputNote");

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
              return events[DateTime(date.year, date.month, date.day)] ?? [];
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
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                focusedDate = focusedDay;
              });
              if (events[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] != null) {
                showEventDetails(context, selectedDay);
              }
            },
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
  String formattedDate = DateFormat.yMMMMd().format(date);
  
  // Check if the selected date is a holiday
  bool isHoliday = events[DateTime(date.year, date.month, date.day)]?.any((event) => event.startsWith("Holiday: ")) ?? false;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Events on $formattedDate"),
      content: SingleChildScrollView(
        child: ListBody(
          children: events[DateTime(date.year, date.month, date.day)]
                  ?.map((event) => Text(event))
                  .toList() ??
              [Text("No events")],
        ),
      ),
      actions: [
        if (!isHoliday) // Only show delete button if it's not a holiday
          TextButton(
            child: Text("Delete"),
            onPressed: () async {
              // Call delete function
              await deleteDate(date);
              Navigator.of(context).pop();
            },
          ),
        TextButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

Future<void> deleteDate(DateTime date) async {
  // Format the date to 'YYYY-MM-DD'
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
      events.remove(DateTime(date.year, date.month, date.day));
    });
  } catch (e) {
    print("Error deleting date: $e");
  }
}
}