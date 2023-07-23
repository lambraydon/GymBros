import 'package:flutter/material.dart';
import 'package:gymbros/screens/calendar/calendar_utils.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/workout_tile.dart';

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
    _selectedEvents = ValueNotifier(
        CalendarUtils.getEventsForDay(_selectedDay!, widget.workoutList));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
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

      _selectedEvents.value =
          CalendarUtils.getEventsForDay(selectedDay, widget.workoutList);
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
      _selectedEvents.value =
          CalendarUtils.getEventsForRange(start, end, widget.workoutList);
    } else if (start != null) {
      _selectedEvents.value =
          CalendarUtils.getEventsForDay(start, widget.workoutList);
    } else if (end != null) {
      _selectedEvents.value =
          CalendarUtils.getEventsForDay(end, widget.workoutList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Calendar'),
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
              eventLoader: (day) =>
                  CalendarUtils.getEventsForDay(day, widget.workoutList),
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
                          editTapped: (context) {},
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
