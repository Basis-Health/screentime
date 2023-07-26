import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:basis_screen_time/screen_time.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  ScreenTimePermissionState _authorized = ScreenTimePermissionState.notDetermined;
  final _manager = ScreenTimeManager.instance;
  late final ScreenTimeBlockSchedule _schedule;

  @override
  void initState() {
    super.initState();
    final currentTime = DateTime.now();
    _schedule = ScreenTimeBlockSchedule(
      id: 'default',
      startTime: Duration(hours: currentTime.hour, minutes: currentTime.minute),
      endTime: Duration(hours: currentTime.hour + 1, minutes: currentTime.minute),
      repeats: true,
    );
    _requestAuth();
  }

  void _requestAuth() async {
    final result = await _manager.requestAuthorization();
    if (result != _authorized && mounted) {
      setState(() => _authorized = result);
    }
  }

  void _getActiveSchedules() async {
    final result = await _manager.activeSchedules();
    log(result.length.toString(), name: 'Active Schedules Length');
  }

  void _getPermissionState() async {
    final result = await _manager.permissionStatus();
    log(result.name, name: 'Permission Status');
  }

  void _deleteSchedule() async {
    await _manager.deleteSchedule('default');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  ScreenTimeManager.instance
                      .scheduleApplicationBlocking(_schedule);
                },
                child: const Text('Select Applications to Block'),
              ),
              TextButton(
                onPressed: _getActiveSchedules,
                child: const Text('Log Active Schedule Length'),
              ),
              TextButton(
                onPressed: () => _deleteSchedule(),
                child: const Text('Delete Default Schedule'),
              ),
              TextButton(
                onPressed: _getPermissionState,
                child: const Text('Log Permission Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
