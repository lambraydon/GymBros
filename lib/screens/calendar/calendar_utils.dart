import 'dart:collection';
import '../workoutTracker/workout.dart';

class CalendarUtils {
  // Return LinkedHashMap for Calendar
  static LinkedHashMap<DateTime, List<Workout>> _initialiseWorkoutMap(List<Workout> workoutList) {
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

  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  /// Checks if two DateTime objects are the same day.
  /// Returns `false` if either of them is null.
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  static List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
          (index) => DateTime(first.year, first.month, first.day + index),
    );
  }

  static List<Workout> getEventsForDay(DateTime day, List<Workout> workoutList) {
    return _initialiseWorkoutMap(workoutList)[day] ?? [];
  }

  static List<Workout> getEventsForRange(DateTime start, DateTime end, List<Workout> workoutList) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ...getEventsForDay(d, workoutList),
    ];
  }
}