part of screen_time;

final class ScreenTimeManager extends ScreenTimeInterface {
  static final instance = ScreenTimeManager();
  @visibleForTesting
  final methodChannel = const MethodChannel('basis_screen_time');

  @override
  Future<bool> isOSSupported() async =>
      await methodChannel.invokeMethod(ScreenTimeMethod.isOSSupported.name);

  @override
  Future<ScreenTimePermissionState> permissionStatus() async {
    final response = await methodChannel
        .invokeMethod(ScreenTimeMethod.permissionStatus.name);
    final data = jsonDecode(jsonEncode(response));
    return ScreenTimePermissionState.fromString(data);
  }

  @override
  Future<ScreenTimePermissionState> requestAuthorization() async {
    final response = await methodChannel
        .invokeMethod(ScreenTimeMethod.requestAuthorization.name);
    final data = jsonDecode(jsonEncode(response));
    return ScreenTimePermissionState.fromString(data);
  }

  @override
  Future<void> scheduleApplicationBlocking(
    ScreenTimeBlockSchedule schedule,
  ) async =>
      await methodChannel.invokeMethod(
        ScreenTimeMethod.scheduleApplicationBlocking.name,
        schedule.toJson(),
      );

  @override
  Future<void> deleteSchedule(String id) async {
    await methodChannel.invokeMethod(
      ScreenTimeMethod.deleteSchedule.name,
      {'id': id},
    );
  }

  @override
  Future<List<ScreenTimeBlockSchedule>> activeSchedules() async {
    final response = await methodChannel.invokeMethod(
      ScreenTimeMethod.activeSchedules.name,
    );
    final data = (jsonDecode(jsonEncode(response)) as List);
    return data.map((e) => ScreenTimeBlockSchedule.fromJson(e)).toList();
  }

  @override
  Future<void> updateSchedule(ScreenTimeBlockSchedule schedule) async {
    await methodChannel.invokeMethod(
      ScreenTimeMethod.updateSchedule.name,
      schedule.toJson(),
    );
  }
}
