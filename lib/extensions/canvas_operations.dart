import 'dart:ui';

/// Renders something to given [Canvas] when called
typedef RenderCallback = void Function(Canvas c);

extension CanvasOperations on Canvas {
  /// Helper for rescaling canvas around the
  /// center of certain bounds [Rect]
  void renderScaled({
    RenderCallback renderer,
    Offset scale,
    Rect bounds,
  }) {
    final center = bounds.center;

    save();
    translate(center.dx, center.dy);
    this.scale(scale.dx, scale.dy);
    translate(-center.dx, -center.dy);
    renderer(this);
    restore();
  }
}
