part of screen_time;

abstract class ScreenTimeInterface {
  Future<bool> requestAuthorization();

  Future<void> scheduleApplicationBlocking(ScreenTimeBlockSchedule schedule);
}

enum ScreenTimeMethod {
  requestAuthorization,
  scheduleApplicationBlocking;
}
