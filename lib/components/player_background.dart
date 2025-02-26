import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:music_player/shaders/shader_painter.dart';

class PlayerBackground extends StatefulWidget {
  const PlayerBackground({super.key});

  @override
  State<PlayerBackground> createState() => _PlayerBackgroundState();
}

class _PlayerBackgroundState extends State<PlayerBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final int _startTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShaderBuilder(
    assetKey: 'assets/shaders/player_background.frag',
    (context, shader, child) {
      _setShaderSize(shader, context);
      _setShaderColors(shader);
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _setShaderTime(shader, _startTime);
          return CustomPaint(painter: ShaderPainter(shader));
        },
      );
    },
  );

  void _setShaderTime(FragmentShader shader, int startTime) =>
      shader.setFloat(0, _elapsedTimeInSeconds(startTime));

  void _setShaderSize(FragmentShader shader, BuildContext context) {
    final size = MediaQuery.of(context).size;
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);
  }

  void _setShaderColors(FragmentShader shader) {
    _setShaderColorPrimary(shader);
    _setShaderColorSecondary(shader);
    _setShaderColorAccent1(shader);
    _setShaderColorAccent2(shader);
  }

  void _setShaderColorPrimary(FragmentShader shader) {
    shader.setFloat(3, Colors.blue.shade700.r);
    shader.setFloat(4, Colors.blue.shade700.g);
    shader.setFloat(5, Colors.blue.shade700.b);
  }

  void _setShaderColorSecondary(FragmentShader shader) {
    shader.setFloat(6, Colors.purple.r);
    shader.setFloat(7, Colors.purple.g);
    shader.setFloat(8, Colors.purple.b);
  }

  void _setShaderColorAccent1(FragmentShader shader) {
    shader.setFloat(9, Colors.purpleAccent.r);
    shader.setFloat(10, Colors.purpleAccent.g);
    shader.setFloat(11, Colors.purpleAccent.b);
  }

  void _setShaderColorAccent2(FragmentShader shader) {
    shader.setFloat(12, Colors.pinkAccent.r);
    shader.setFloat(13, Colors.pinkAccent.g);
    shader.setFloat(14, Colors.pinkAccent.b);
  }

  double _elapsedTimeInSeconds(int startTime) =>
      (DateTime.now().millisecondsSinceEpoch - startTime) / 1000;
}
