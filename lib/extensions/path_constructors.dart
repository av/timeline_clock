import 'dart:ui';

import 'package:flutter/foundation.dart';

extension PathConstructors on Path {
  /// Constructs a basic scale, consisting of ticks
  /// lines within given bounds [Rect]
  static Path scale({
    @required Rect bounds,
    double ticks = 100,
    double longerTicks = 10,
    double secondaryTicks = 5,
    bool upwards = true,
    double smallTickFactor = .5,
  }) {
    final path = Path();
    final offsetStep = Offset(bounds.width / ticks, 0);
    final startingCorner = upwards ? bounds.bottomLeft : bounds.topLeft;
    final height = upwards ? -bounds.height : bounds.height;
    final halfHeight = smallTickFactor * height;

    for (double i = 0; i <= ticks; i++) {
      Offset lineOffset = startingCorner + offsetStep * i;
      final lineHeight = i % longerTicks == 0
          ? height
          : i % secondaryTicks == 0 ? height * .5 : halfHeight;

      path.moveTo(lineOffset.dx, lineOffset.dy);
      path.lineTo(lineOffset.dx, lineOffset.dy + lineHeight * 2);
    }

    return path;
  }
}
