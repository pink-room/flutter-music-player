import 'dart:ui';

import 'package:flutter/widgets.dart';

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;

  const ShaderPainter(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate != this;
}
