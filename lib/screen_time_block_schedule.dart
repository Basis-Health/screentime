part of screen_time;

final class ScreenTimeBlockSchedule {
  final String id;
  final Duration startTime;
  final Duration endTime;
  final bool repeats;

  const ScreenTimeBlockSchedule({
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

  @override
  int get hashCode => Object.hash(
    id, startTime, endTime, repeats);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenTimeBlockSchedule &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          repeats == other.repeats;

  ScreenTimeBlockSchedule copyWith({
    String? id,
    Duration? startTime,
    Duration? endTime,
    bool? repeats,
  }) {
    return ScreenTimeBlockSchedule(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      repeats: repeats ?? this.repeats,
    );
  }
}

extension DateTimeSchedule on Duration {
  Map<String, dynamic> toSchedule() => {
        'hour': inHours % 24,
        'minute': inMinutes % 60,
        'second': inSeconds % 60,
      };

  static Duration fromJson(Map<String, dynamic> json) {
    return Duration(
      hours: json['hour'],
      minutes: json['minute'],
      seconds: json['second'],
    );
  }
}

enum ScreenTimePermissionState {
  authorized,
  denied,
  notDetermined;

  static ScreenTimePermissionState fromString(String val) {
    return ScreenTimePermissionState.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase());
  }
}
