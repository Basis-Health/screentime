part of screen_time;

class ScreenTimeBlockSchedule {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool repeats;

  ScreenTimeBlockSchedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.repeats,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'startTime': startTime.toSchedule(),
        'endTime': endTime.toSchedule(),
        'repeats': repeats,
      };
}

extension DateTimeSchedule on DateTime {
  Map<String, dynamic> toSchedule() => {
        'hour': hour,
        'minute': minute,
        'second': second,
      };
}
