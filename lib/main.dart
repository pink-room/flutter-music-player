import 'package:flutter/material.dart';
import 'package:music_player/components/music_player.dart';
import 'package:music_player/components/player_background.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [const PlayerBackground(), SafeArea(child: MusicPlayer())],
        ),
      ),
    );
  }
}
