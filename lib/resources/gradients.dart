import 'package:digital_clock/components/color_transition.dart';
import 'package:flutter/material.dart';

/// List of gradients to cycle through during the day.
final List<ColorTransition> skyboxGradients = [
  '#00000c 0%, #00000c 100%', // 0
  '#020111 85%, #191621 100%',
  '#020111 60%, #20202c 100%',
  '#020111 10%, #3a3a52 100%',
  '#20202c 0%,#515175 100%',
  '#40405c 0%,#6f71aa 80%,#8a76ab 100%', // 5
  '#4a4969 0%,#7072ab 70%,#cd82a0 100%',
  '#757abf 0%,#8583be 70%,#eab0d1 100%',
  '#82addb 0%,#ebb2b1 100%',
  '#94c5f8 1%,#a6e6ff 70%,#b1b5ea 100%',
  '#b7eaff 0%,#94dfff 100%', // 10
  '#9be2fe 0%,#67d1fb 100%',
  '#90dffe 0%,#38a3d1 100%',
  '#57c1eb 0%,#246fa8 100%',
  '#2d91c2 0%,#1e528e 100%',
  '#2473ab 0%,#5b7983 100%', // 15
  '#1e528e 0%,#9da671 100%',
  '#1e528e 0%,#e9ce5d 100%',
  '#154277 0%,#b26339 100%', // 18
  '#163C52 0%,#2F1107 100%',
  '#071B26 0%,#240E03 100%',
  '#010A10 0%, #2F1107 100%',
  '#090401 00%, #4B1D06 100%',
  '#00000c 00%,#150800 100%',
  '#00000c 0%, #00000c 100%',
]
    .map<ColorTransition>(
      (str) => ColorTransition.fromCSSString(str),
    )
    .toList();

final ColorTransition hoursShaft = ColorTransition(colors: [
  Colors.white.withOpacity(.5),
  Colors.white.withOpacity(0)
], stops: [
  0,
  0.5,
]);

final ColorTransition minutesShaft = ColorTransition(colors: [
  Colors.white.withOpacity(0),
  Colors.white.withOpacity(.5),
  Colors.white.withOpacity(0)
], stops: [
  0.25,
  0.5,
  0.75
]);

final ColorTransition secondsShaft = ColorTransition(colors: [
  Colors.white.withOpacity(0),
  Colors.white.withOpacity(.3),
], stops: [
  0.5,
  1.0,
]);
