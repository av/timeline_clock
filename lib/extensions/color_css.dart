import 'dart:ui';

/// Allows instantiating [Color] from
/// CSS Hex string
extension CSSColors on Color {
  static Color fromCSSString(String cssColor) {
    cssColor = cssColor.substring(1);

    final r = int.parse(cssColor.substring(0, 2), radix: 16);
    final g = int.parse(cssColor.substring(2, 4), radix: 16);
    final b = int.parse(cssColor.substring(4, 6), radix: 16);

    return Color.fromARGB(0xff, r, g, b);
  }
}
