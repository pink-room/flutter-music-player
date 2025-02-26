import 'package:flutter/widgets.dart';

extension ContextExtensions on BuildContext {
  bool get isOrientationPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
}
