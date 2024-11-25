import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

String formatTimeWithoutMinutes(BuildContext context, TimeOfDay time) {
  final formattedTime = time.format(context);
  return formattedTime
      .replaceAll(':00', '')
      .replaceAll('10 AM', '10AM')
      .replaceAll('11 AM', '11AM')
      .replaceAll('12 PM', '12PM');
}

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, dynamic>> classes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[10],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double padding = 7.0;
          final double maxScreenWidth =
              constraints.maxWidth - padding * 2; // Take padding into account
          final double screenWidth =
              maxScreenWidth > 600 ? 600 : maxScreenWidth;
          final double cellWidth = screenWidth / 8;
          final double cellHeight =
              cellWidth * 1.4; // Adjust the aspect ratio as needed

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: padding), // Add padding here
                child: Container(
                  width: screenWidth,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                          "Weekly Schedule",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.red[300]!,
                                offset: Offset(3.0, 3.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: cellWidth,
                            height: cellHeight,
                            child: Center(child: Text('')),
                          ),
                          ...List.generate(7, (index) {
                            return Container(
                              width: cellWidth,
                              height: cellHeight,
                              child: Center(
                                child: Text(
                                  [
                                    'Sun',
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri',
                                    'Sat'
                                  ][index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      ...List.generate(12, (timeIndex) {
                        final currentTime =
                            TimeOfDay(hour: 7 + timeIndex, minute: 0);
                        return Row(
                          children: [
                            Container(
                              width: cellWidth,
                              height: cellHeight,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    formatTimeWithoutMinutes(
                                        context, currentTime),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ...List.generate(7, (dayIndex) {
                              final classForTimeSlot = classes.firstWhere(
                                (classItem) =>
                                    classItem['day'] == dayIndex &&
                                    classItem['startTime'].hour <=
                                        currentTime.hour &&
                                    classItem['endTime'].hour >
                                        currentTime.hour,
                                orElse: () => {},
                              );

                              bool isClassBlock = classForTimeSlot.isNotEmpty;
                              bool isFirstSlot = isClassBlock &&
                                  classForTimeSlot['startTime'].hour ==
                                      currentTime.hour;

                              return GestureDetector(
                                onTap: () => isClassBlock
                                    ? _editClass(classForTimeSlot)
                                    : _addClass(dayIndex, currentTime),
                                child: Container(
                                  width: cellWidth,
                                  height: cellHeight,
                                  decoration: BoxDecoration(
                                    color: isClassBlock
                                        ? classForTimeSlot['color']
                                            .withOpacity(0.7)
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.red[100]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red[100]!,
                                        blurRadius: 5,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: isFirstSlot
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                classForTimeSlot['name'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                classForTimeSlot['instructor'],
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )
                                        : null,
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClassPrompt,
        backgroundColor: Colors.red[100],
        child: Icon(Icons.add),
      ),
    );
  }

  void _addClassPrompt() async {
    final newClass = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return _ClassDialog();
      },
    );

    if (newClass != null) {
      setState(() {
        classes.add(newClass);
      });
    }
  }

  void _addClass(int dayIndex, TimeOfDay currentTime) async {
    final newClass = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return _ClassDialog(
          initialDay: dayIndex,
          initialStartTime: currentTime,
          initialEndTime: TimeOfDay(hour: currentTime.hour + 1, minute: 0),
        );
      },
    );

    if (newClass != null) {
      setState(() {
        classes.add(newClass);
      });
    }
  }

  void _editClass(Map<String, dynamic> classItem) async {
    final editedClass = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return _ClassDialog(classItem: classItem);
      },
    );

    if (editedClass != null) {
      if (editedClass.containsKey('delete') && editedClass['delete']) {
        setState(() {
          classes.remove(classItem);
        });
      } else {
        setState(() {
          classes = classes.map((c) {
            if (c == classItem) return editedClass;
            return c;
          }).toList();
        });
      }
    }
  }
}

class _ClassDialog extends StatefulWidget {
  final Map<String, dynamic>? classItem;
  final int? initialDay;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;

  _ClassDialog({
    this.classItem,
    this.initialDay,
    this.initialStartTime,
    this.initialEndTime,
  });

  @override
  __ClassDialogState createState() => __ClassDialogState();
}

class __ClassDialogState extends State<_ClassDialog> {
  final classNameController = TextEditingController();
  final instructorNameController = TextEditingController();
  TimeOfDay startTime = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 8, minute: 0);
  int selectedDay = 0;
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    if (widget.classItem != null) {
      final classItem = widget.classItem!;
      classNameController.text = classItem['name'];
      instructorNameController.text = classItem['instructor'];
      startTime = classItem['startTime'];
      endTime = classItem['endTime'];
      selectedDay = classItem['day'];
      selectedColor = classItem['color'];
    } else {
      if (widget.initialDay != null) selectedDay = widget.initialDay!;
      if (widget.initialStartTime != null) startTime = widget.initialStartTime!;
      if (widget.initialEndTime != null) endTime = widget.initialEndTime!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Class Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: classNameController,
            decoration: InputDecoration(labelText: 'Class Name'),
          ),
          TextField(
            controller: instructorNameController,
            decoration: InputDecoration(labelText: 'Instructor Name'),
          ),
          DropdownButton<int>(
            value: selectedDay,
            items: List.generate(
              7,
              (index) => DropdownMenuItem(
                value: index,
                child: Text([
                  'Sunday',
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday'
                ][index]),
              ),
            ),
            onChanged: (value) {
              if (value != null) setState(() => selectedDay = value);
            },
          ),
          Row(
            children: [
              Text('Start Time:'),
              Spacer(),
              TextButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: startTime,
                  );
                  if (time != null) setState(() => startTime = time);
                },
                child: Text(startTime.format(context)),
              ),
            ],
          ),
          Row(
            children: [
              Text('End Time:'),
              Spacer(),
              TextButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: endTime,
                  );
                  if (time != null) setState(() => endTime = time);
                },
                child: Text(endTime.format(context)),
              ),
            ],
          ),
          Row(
            children: [
              Text('Color:'),
              Spacer(),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: selectedColor,
                          onColorChanged: (color) {
                            setState(() => selectedColor = color);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 30,
                  height: 30,
                  color: selectedColor,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, {
              'name': classNameController.text,
              'instructor': instructorNameController.text,
              'day': selectedDay,
              'startTime': startTime,
              'endTime': endTime,
              'color': selectedColor,
            });
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
