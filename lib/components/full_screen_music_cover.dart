import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/common/constants.dart';

class FullScreenMusicCover extends StatelessWidget {
  const FullScreenMusicCover({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.pop(context),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Colors.black.withAlpha(150),
        body: Center(
          child: Hero(
            tag: Constants.coverPath,
            child: Image.asset(Constants.coverPath, fit: BoxFit.cover),
          ),
        ),
      ),
    ),
  );
}
