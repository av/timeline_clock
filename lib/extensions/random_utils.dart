import 'dart:math';

extension RandomUtils on Random {
  /// Allows to obtain a random [double] between
  /// given bounds, inclusive.
  doubleBetween(double from, double to) {
    return from + (to - from) * nextDouble();
  }
}
