import 'package:digital_clock/extensions/color_css.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:digital_clock/extensions/tween_sequence_sampling.dart';

/// Defines options to recreate [ui.Gradient] from.
/// Allows to lerp between different states and smoothen
/// gradients for non-linear color transition (using sampling).
class ColorTransition {
  final List<Color> colors;
  final List<double> stops;

  /// Mixes two [ColorTransition] instances with given amount.
  static ColorTransition lerp(
    ColorTransition a,
    ColorTransition b,
    double amount,
  ) {
    final samples = 25;
    final stops = List.generate(samples, (i) => (1 / samples) * i);
    final aColors = a.sequenize(Curves.linear).sample(samples: samples);
    final bColors = b.sequenize(Curves.linear).sample(samples: samples);

    final colors = List<Color>.generate(
      aColors.length,
      (i) => Color.lerp(
        aColors[i],
        bColors[i],
        amount,
      ),
    );

    return ColorTransition(
      colors: colors,
      stops: stops,
    );
  }

  /// Instantiates a [ColorTransition] from given CSS String.
  static ColorTransition fromCSSString(String cssString) {
    final colorStopPairs =
        cssString.split(',').map<String>((s) => s.trim()).toList();
    final colors = <Color>[];
    final stops = <double>[];

    for (final pair in colorStopPairs) {
      final parts = pair.split(' ');
      final color = CSSColors.fromCSSString(parts.first);
      final stop = num.parse(parts.last.replaceAll(RegExp('%'), '')) / 100;

      colors.add(color);
      stops.add(stop);
    }

    return ColorTransition(
      colors: colors,
      stops: stops,
    );
  }

  ColorTransition({
    @required this.colors,
    @required this.stops,
  });

  /// Returns a new instance of this transition, with more color stops
  /// and easing applied for color change
  smoothen({
    int steps,
    Curve easing,
  }) {
    final tween = sequenize(easing);

    return ColorTransition(
      colors: List.generate(steps, (i) {
        return tween.transform(i / steps);
      }),
      stops: List.generate(steps, (i) => i / steps),
    );
  }

  TweenSequence<Color> sequenize([Curve easing = Curves.linear]) {
    return TweenSequence<Color>(
      List<TweenSequenceItem<Color>>.generate(
        colors.length - 1,
        (i) => TweenSequenceItem(
          tween: ColorTween(begin: colors[i], end: colors[i + 1]).chain(
            CurveTween(
              curve: easing,
            ),
          ),
          weight: (stops[i + 1] - stops[i]),
        ),
      ),
    );
  }
}
