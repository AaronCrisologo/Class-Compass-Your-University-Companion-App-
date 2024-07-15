import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, dynamic>> classes = [];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Class Scheduler"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width: screenWidth / 8,
                    height: 60,
                    child: Center(child: Text(''))),
                ...List.generate(7, (index) {
                  return Container(
                    width: screenWidth / 8,
                    height: 60,
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ],
            ),
            ...List.generate(13, (timeIndex) {
              final currentTime = TimeOfDay(hour: 7 + timeIndex, minute: 0);
              return Row(
                children: [
                  Container(
                    width: screenWidth / 8,
                    height: screenHeight / 15,
                    child: Center(
                      child: Text('${currentTime.format(context)}'),
                    ),
                  ),
                  ...List.generate(7, (dayIndex) {
                    final classForTimeSlot = classes.firstWhere(
                      (classItem) =>
                          classItem['day'] == dayIndex &&
                          classItem['startTime'].hour <= currentTime.hour &&
                          classItem['endTime'].hour > currentTime.hour,
                      orElse: () => {},
                    );

                    bool isClassBlock = classForTimeSlot.isNotEmpty;
                    bool isFirstSlot = classForTimeSlot.isNotEmpty &&
                        classForTimeSlot['startTime'].hour == currentTime.hour;

                    return GestureDetector(
                      onTap: () => isClassBlock
                          ? _editClass(classForTimeSlot)
                          : _addClass(dayIndex, currentTime),
                      child: Container(
                        width: screenWidth / 8,
                        height: screenHeight / 15,
                        decoration: BoxDecoration(
                          color: isClassBlock
                              ? classForTimeSlot['color'].withOpacity(0.5)
                              : null,
                          border: Border.all(
                            color:
                                isClassBlock ? Colors.transparent : Colors.grey,
                          ),
                        ),
                        child: Center(
                          child: isFirstSlot
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      classForTimeSlot['name'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      classForTimeSlot['instructor'],
                                      style: TextStyle(
                                        fontSize: 10,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addClassPrompt,
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
      classNameController.text = widget.classItem!['name'];
      instructorNameController.text = widget.classItem!['instructor'];
      selectedDay = widget.classItem!['day'];
      startTime = widget.classItem!['startTime'];
      endTime = widget.classItem!['endTime'];
      selectedColor = widget.classItem!['color'];
    } else {
      if (widget.initialDay != null) selectedDay = widget.initialDay!;
      if (widget.initialStartTime != null) startTime = widget.initialStartTime!;
      if (widget.initialEndTime != null) endTime = widget.initialEndTime!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.classItem != null ? 'Edit Class' : 'Add Class'),
      content: SingleChildScrollView(
        child: Column(
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
              onChanged: (value) {
                setState(() {
                  selectedDay = value!;
                });
              },
              items: List.generate(7, (index) {
                return DropdownMenuItem(
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
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start Time: ${startTime.format(context)}'),
                TextButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (picked != null) {
                      setState(() {
                        startTime = picked;
                      });
                    }
                  },
                  child: Text('Select'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('End Time: ${endTime.format(context)}'),
                TextButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (picked != null) {
                      setState(() {
                        endTime = picked;
                      });
                    }
                  },
                  child: Text('Select'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Class Color'),
                IconButton(
                  icon: Icon(Icons.color_lens, color: selectedColor),
                  onPressed: () async {
                    final pickedColor = await showDialog<Color>(
                      context: context,
                      builder: (context) {
                        Color tempColor = selectedColor;
                        return AlertDialog(
                          title: Text('Pick a color'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: selectedColor,
                              onColorChanged: (color) {
                                tempColor = color;
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(tempColor);
                              },
                              child: Text('Select'),
                            ),
                          ],
                        );
                      },
                    );

                    if (pickedColor != null) {
                      setState(() {
                        selectedColor = pickedColor;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        if (widget.classItem != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop({'delete': true});
            },
            child: Text('Delete'),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop({
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
