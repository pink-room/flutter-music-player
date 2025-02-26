import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/components/play_pause_button.dart';

// Code copied from https://github.com/ryanheise/just_audio/blob/minor/just_audio/example/lib/main.dart#L119

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up),
          color: Colors.white,
          onPressed: () {
            _showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing ?? false;
            if (processingState == ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.replay),
                color: Colors.white,
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
            return PlayPauseButton(
              isPlaying: playing,
              onPressed: playing ? player.pause : player.play,
            );
          },
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder:
              (context, snapshot) => IconButton(
                icon: Text(
                  "${snapshot.data?.toStringAsFixed(1)}x",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _showSliderDialog(
                    context: context,
                    title: "Adjust speed",
                    divisions: 10,
                    min: 0.5,
                    max: 1.5,
                    value: player.speed,
                    stream: player.speedStream,
                    onChanged: player.setSpeed,
                  );
                },
              ),
        ),
      ],
    );
  }

  void _showSliderDialog({
    required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    String valueSuffix = '',
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
  }) => showDialog<void>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: StreamBuilder<double>(
            stream: stream,
            builder:
                (context, snapshot) => SizedBox(
                  height: 100.0,
                  child: Column(
                    children: [
                      Text(
                        '${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      Slider(
                        divisions: divisions,
                        min: min,
                        max: max,
                        value: snapshot.data ?? value,
                        onChanged: onChanged,
                      ),
                    ],
                  ),
                ),
          ),
        ),
  );
}
