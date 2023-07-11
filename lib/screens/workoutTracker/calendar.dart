import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/workoutTile.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key, required this.workoutList});
  final List<Workout> workoutList;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<Workout>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  // Return LinkedHashMap for Calendar
  LinkedHashMap<DateTime, List<Workout>> initialiseWorkoutMap(List<Workout> workoutList) {
    Map<DateTime, List<Workout>> temp = {};
    for (int i = 0; i < workoutList.length; i++) {
      DateTime index = workoutList[i].start;
      DateTime key = DateTime(index.year, index.month, index.day);
      if (temp.containsKey(key)) {
        List<Workout>? workouts = temp[key];
        workouts?.add(workoutList[i]);
        temp.update(key, (value) => workouts!);
      } else {
        temp[key] = [workoutList[i]];
      }
    }
    return LinkedHashMap<DateTime, List<Workout>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(temp);
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  /// Checks if two DateTime objects are the same day.
  /// Returns `false` if either of them is null.
  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
          (index) => DateTime(first.year, first.month, first.day + index),
    );
  }

  List<Workout> _getEventsForDay(DateTime day) {
    // Implementation example
    return initialiseWorkoutMap(widget.workoutList)[day] ?? [];
  }

  List<Workout> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Calendar-view'),
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            TableCalendar<Workout>(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2023, 12, 1),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: (day) => _getEventsForDay(day),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Workout>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return WorkoutTile(
                          workout: value[index],
                          editTapped: (context) {} ,
                          deleteTapped: (context) {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
