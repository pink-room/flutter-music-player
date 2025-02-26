import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/common/context_extensions.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MusicCoverState extends State<MusicCover> {
  final double _alpha = 0.03;
  final double _maxRotation = 0.3;
  final double _shadowOffsetMultiplier = 100;
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
    final verticalRotation = isPortrait ? _xRotation : _yRotation;
    final horizontalRotation = isPortrait ? _yRotation : _xRotation;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(90),
            spreadRadius: 2,
            blurRadius: 14,
            offset: Offset(
              4 + (horizontalRotation * _shadowOffsetMultiplier),
              4 - (verticalRotation * _shadowOffsetMultiplier),
            ),
          ),
        ],
      ),
      child: Transform(
        transform:
            Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(verticalRotation)
              ..rotateY(horizontalRotation),
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
}

class MusicCover extends StatefulWidget {
  const MusicCover({super.key});

  @override
  State<StatefulWidget> createState() => MusicCoverState();
}
