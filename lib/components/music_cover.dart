import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/common/context_extensions.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MusicCoverState extends State<MusicCover> {
  final double _alpha = 0.03;
  final double _maxRotation = 0.3;
  final double _shadowOffsetMultiplier = 20;
  final _gyroscopeStream = gyroscopeEventStream(
    samplingPeriod: SensorInterval.uiInterval,
  );
  late final StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  double _xRotation = 0;
  double _yRotation = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = context.isOrientationPortrait;
    final xRotation = _getXRotation(isPortrait);
    final yRotation = _getYRotation(isPortrait);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(70),
            spreadRadius: 2,
            blurRadius: 16,
            offset: Offset(
              4 + yRotation * _shadowOffsetMultiplier,
              4 + -xRotation * _shadowOffsetMultiplier,
            ),
          ),
        ],
      ),
      child: Transform(
        transform:
            Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(xRotation)
              ..rotateY(yRotation),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            "assets/images/cover.jpg",
            fit: BoxFit.cover,
            width: 280,
            height: 280,
          ),
        ),
      ),
    );
  }

  void _init() {
    _gyroscopeSubscription = _gyroscopeStream.listen((event) {
      setState(() {
        // Apply EMA Low-pass filter
        final x = _alpha * event.x + (1 - _alpha) * _xRotation;
        final y = _alpha * event.y + (1 - _alpha) * _yRotation;
        // Clamp values to stay within the max rotation range
        _xRotation = x.clamp(-_maxRotation, _maxRotation);
        _yRotation = y.clamp(-_maxRotation, _maxRotation);
      });
    });
  }

  double _getXRotation(bool isPortrait) {
    if (isPortrait) return _xRotation;
    return _yRotation;
  }

  double _getYRotation(bool isPortrait) {
    if (isPortrait) return _yRotation;
    return _xRotation;
  }
}

class MusicCover extends StatefulWidget {
  const MusicCover({super.key});

  @override
  State<StatefulWidget> createState() => MusicCoverState();
}
