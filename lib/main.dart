// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:digital_clock/clock.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);
  await SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(ClockApp());
}

class ClockApp extends StatefulWidget {
  @override
  _ClockAppState createState() => _ClockAppState();
}

class _ClockAppState extends State<ClockApp> {
  final game = Clock();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AspectRatio(
            aspectRatio: 5 / 3,
            child: game.widget,
          ),
        ),
      ),
    );
  }
}
