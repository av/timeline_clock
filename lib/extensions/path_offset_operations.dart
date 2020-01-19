import 'dart:ui';

import 'package:digital_clock/extensions/offset_operations.dart';

extension PathOffsetOperations on Path {
  void moveToOffset(Offset offset) {
    this.moveTo(offset.dx, offset.dy);
  }

  void lineToOffset(Offset offset) {
    this.lineTo(offset.dx, offset.dy);
  }

  void anchorsTo(List<Offset> points) {
    final path = this;
    Offset previousPoint = points.first.midpoint(points[1]),
        anchor,
        previousAnchor;

    path.moveTo(points.first.dx, points.first.dy);
    path.lineTo(previousPoint.dx, previousPoint.dy);

    for (int i = 1; i < points.length; i++) {
      anchor = points[i];
      previousAnchor = points[i - 1];

      final nextPoint = previousAnchor.midpoint(anchor);

      path.quadraticBezierTo(
        previousAnchor.dx,
        previousAnchor.dy,
        nextPoint.dx,
        nextPoint.dy,
      );

      previousPoint = nextPoint;
    }
  }

  void beziersTo(List<Offset> points, {double anchorMultiplier = 1}) {
    moveToOffset(points.first);

    for (int i = 1; i < points.length; i++) {
      final current = points[i];
      final previous = points[i - 1];
      final anchorSize =
          (current.dx - previous.dx).abs().clamp(100, 300) * anchorMultiplier;

      this.cubicTo(
        previous.dx,
        previous.dy + anchorSize,
        current.dx,
        current.dy - anchorSize,
        current.dx,
        current.dy,
      );
    }
  }
}
