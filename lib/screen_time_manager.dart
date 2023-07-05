part of screen_time;

class ScreenTimeManager extends ScreenTimeInterface {
  static var instance = ScreenTimeManager();
  @visibleForTesting
  final methodChannel = const MethodChannel('basis_screen_time');

  @override
  Future<bool> requestAuthorization() async => await methodChannel
      .invokeMethod(ScreenTimeMethod.requestAuthorization.name);

  @override
  Future<void> scheduleApplicationBlocking(
    ScreenTimeBlockSchedule schedule,
  ) async =>
      await methodChannel.invokeMethod(
        ScreenTimeMethod.scheduleApplicationBlocking.name,
        schedule.toJson(),
      );
}
