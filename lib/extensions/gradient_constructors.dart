import 'dart:ui';

import 'package:digital_clock/components/color_transition.dart';
import 'package:flutter/material.dart' hide Gradient;

/// Utilities for instantiating [Gradient] instances
extension GradientConstructors on Gradient {
  static Gradient forColors({
    List<Color> colors = const [Colors.black, Colors.white],
    Offset from = Offset.zero,
    Offset to = Offset.zero,
    List<double> stops,
  }) {
    return Gradient.linear(
      from,
      to,
      colors,
      List.generate(colors.length, (i) => i / colors.length),
    );
  }

  static Gradient fromColorTransition({
    ColorTransition transition,
    Offset from,
    Offset to,
  }) {
    return Gradient.linear(from, to, transition.colors, transition.stops);
  }

  static Gradient smoothLinear({
    List<Color> colors = const [Colors.black, Colors.white],
    Offset from = Offset.zero,
    Offset to = Offset.zero,
    List<double> stops,
    int steps = 2,
    Curve easing = Curves.ease,
  }) {
    final colorTransition =
        ColorTransition(colors: colors, stops: stops).smoothen(
      steps: steps,
      easing: easing,
    );

    return Gradient.linear(
      from,
      to,
      colorTransition.colors,
      colorTransition.stops,
    );
  }
}
