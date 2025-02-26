import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/components/music_player.dart';
import 'package:music_player/components/player_background.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initEdgeToEdge();
  runApp(const MyApp());
}

void _initEdgeToEdge() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );
}

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
        extendBodyBehindAppBar: true,
        body: Stack(
          fit: StackFit.expand,
          children: [const PlayerBackground(), SafeArea(child: MusicPlayer())],
        ),
      ),
    );
  }
}
