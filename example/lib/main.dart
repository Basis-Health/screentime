import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
  bool _authorized = false;
  final _manager = ScreenTimeManager.instance;
  final schedule = ScreenTimeBlockSchedule(
    id: 'default',
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(minutes: 30)),
    repeats: true,
  );

  @override
  void initState() {
    super.initState();
    _requestAuth();
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
                      .scheduleApplicationBlocking(schedule);
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

  void _requestAuth() async {
    final result = await _manager.requestAuthorization();
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
}
