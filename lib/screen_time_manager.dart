part of screen_time;

class ScreenTimeManager extends ScreenTimeInterface {
  static var instance = ScreenTimeManager();
  @visibleForTesting
  final methodChannel = const MethodChannel('basis_screen_time');

  Future<bool> requestAuthorization() async => await methodChannel
      .invokeMethod(ScreenTimeMethod.requestAuthorization.name);

  @override
  Future<void> presentActivitySelector() async => await methodChannel
      .invokeMethod(ScreenTimeMethod.presentActivitySelector.name);
}
