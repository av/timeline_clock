import 'package:flutter/material.dart';

final smokeColorTween = TweenSequence<Color>([
  TweenSequenceItem(
    tween: ColorTween(begin: Colors.transparent, end: Colors.white54),
    weight: 1,
  ),
  TweenSequenceItem(
    tween: ColorTween(begin: Colors.white54, end: Colors.white54),
    weight: 1,
  ),
  TweenSequenceItem(
    tween: ColorTween(begin: Colors.white54, end: Colors.white.withOpacity(0)),
    weight: 5,
  ),
]);

final enterStayLeaveTween = TweenSequence([
  TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
  TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 3),
  TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
]);

final starSpawnProbabilityTween = TweenSequence([
  TweenSequenceItem(tween: Tween(begin: .8, end: 0.0), weight: 6),
  TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 10),
  TweenSequenceItem(tween: Tween(begin: 0.0, end: .8), weight: 8),
]);
