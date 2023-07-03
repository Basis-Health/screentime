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
          child: TextButton(
            onPressed: ScreenTimeManager.instance.presentActivitySelector,
            child: Text('Select Applications to Block'),
          ),
        ),
      ),
    );
  }

  void _requestAuth() async {
    final result = await _manager.requestAuthorization();
    setState(() => _authorized = result);
  }
}
