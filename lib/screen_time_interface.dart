part of screen_time;

abstract class ScreenTimeInterface {
  Future<bool> requestAuthorization();
  Future<void> presentActivitySelector();
}

enum ScreenTimeMethod {
  requestAuthorization,
  presentActivitySelector;
}