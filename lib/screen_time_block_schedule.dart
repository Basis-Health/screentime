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

  factory ScreenTimeBlockSchedule.fromJson(Map<String, dynamic> json) {
    return ScreenTimeBlockSchedule(
      id: json['id'],
      startTime: DateTimeSchedule.fromJson(json['startTime']),
      endTime: DateTimeSchedule.fromJson(json['endTime']),
      repeats: json['repeats'],
    );
  }
}

extension DateTimeSchedule on DateTime {
  Map<String, dynamic> toSchedule() => {
        'hour': hour,
        'minute': minute,
        'second': second,
      };

  static DateTime fromJson(Map<String, dynamic> json) {
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      json['hour'],
      json['minute'],
      json['second'],
    );
  }
}

enum ScreenTimePermissionState {
  authorized,
  denied,
  notDetermined;

  static ScreenTimePermissionState fromString(String val) {
    return ScreenTimePermissionState.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase(),
    );
  }
}
