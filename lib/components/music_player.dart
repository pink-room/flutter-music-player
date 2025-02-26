import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/common/constants.dart';
import 'package:music_player/common/context_extensions.dart';
import 'package:music_player/components/control_buttons.dart';
import 'package:music_player/components/full_screen_music_cover.dart';
import 'package:music_player/components/music_cover.dart';
import 'package:music_player/components/seek_bar.dart';
import 'package:rxdart/rxdart.dart';

// Code copied from https://github.com/ryanheise/just_audio/blob/minor/just_audio/example/lib/main.dart

class MusicPlayerState extends State<MusicPlayer> with WidgetsBindingObserver {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    _player.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = context.isOrientationPortrait;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Flex(
        direction: isPortrait ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _showCoverInFullScreen,
            child: Hero(tag: Constants.coverPath, child: MusicCover()),
          ),
          const SizedBox(width: 24, height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ControlButtons(_player),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: _player.seek,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse("https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac"),
        ),
      );
    } on PlayerException catch (e) {
      if (kDebugMode) print("Error loading audio source: $e");
    }
  }

  void _showCoverInFullScreen() => Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) => FullScreenMusicCover(),
    ),
  );

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<StatefulWidget> createState() => MusicPlayerState();
}
