import 'dart:math';
import 'dart:ui';

import 'package:digital_clock/utils.dart';
import 'package:digital_clock/extensions/random_utils.dart';

extension OffsetOperations on Offset {
  Offset rotate(double degrees) {
    final cs = cos(degrees);
    final sn = sin(degrees);

    return Offset(
      this.dx * cs - this.dy * sn,
      this.dy * cs + this.dx * sn,
    );
  }

  Offset midpoint(Offset other) {
    return Offset(
      this.dx + (other.dx - this.dx) / 2,
      this.dy + (other.dy - this.dy) / 2,
    );
  }

  static Offset randomInRect(Rect bounds) {
    return Offset(
      rnd.doubleBetween(bounds.left, bounds.right),
      rnd.doubleBetween(bounds.top, bounds.bottom),
    );
  }
}
