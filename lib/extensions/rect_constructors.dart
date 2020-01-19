import 'dart:ui';

extension RectConstructors on Rect {
  /// Returns a new [Rect], representing a
  /// square with center in [Offset.zero]
  static Rect centeredSquare([double side = 10]) {
    final halfside = -side / 2;
    return Rect.fromLTWH(halfside, halfside, side, side);
  }
}
