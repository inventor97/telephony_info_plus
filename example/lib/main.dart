import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:telephony_info_plus/telephony_info_plus.dart';
import 'package:telephony_info_plus/telephony_info_plus_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _telephonyInfoPlusPlugin = TelephonyInfoPlus();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    List<TelephonyInfo>? platformVersion;
    try {
      platformVersion =
          await _telephonyInfoPlusPlugin.getSimInfos();
    } catch(e) {
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
