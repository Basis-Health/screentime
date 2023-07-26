part of screen_time;

abstract class ScreenTimeInterface {
  Future<List<ScreenTimeBlockSchedule>> activeSchedules();

  Future<bool> isOSSupported();

  Future<ScreenTimePermissionState> permissionStatus();

  Future<ScreenTimePermissionState> requestAuthorization();

  Future<void> scheduleApplicationBlocking(ScreenTimeBlockSchedule schedule);

  Future<void> deleteSchedule(String id);

  Future<void> updateSchedule(ScreenTimeBlockSchedule schedule);
}

enum ScreenTimeMethod {
  isOSSupported,
  permissionStatus,
  requestAuthorization,
  scheduleApplicationBlocking,
  activeSchedules,
  deleteSchedule,
  updateSchedule;
}
