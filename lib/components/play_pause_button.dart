import 'package:flutter/material.dart';

class PlayPauseButton extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const PlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.onPressed,
  });

  @override
  PlayPauseButtonState createState() => PlayPauseButtonState();
}

class PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    if (widget.isPlaying) _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 64,
      icon: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: _animationController,
        color: Colors.white,
      ),
      onPressed: _togglePlayPause,
    );
  }

  void _togglePlayPause() {
    widget.isPlaying
        ? _animationController.reverse()
        : _animationController.forward();
    widget.onPressed();
  }
}
