import 'dart:ui';

import 'package:digital_clock/resources/tweens.dart';
import 'package:digital_clock/utils.dart';
import 'package:flame/particle.dart';
import 'package:flame/particles/computed_particle.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart' hide Gradient;

/// Returns a new [Particle] which fades in, lives
/// for a while and fades out
Particle sparkleParticle({
  double radius = 2.0,
  double radiusVariation = .5,
  double lifespan = 1.0,
  Animatable<Color> colorTween,
}) {
  final usedColorTween = colorTween ?? smokeColorTween;
  final particleRadius = radius - (rnd.nextDouble() * radiusVariation) * radius;
  final paint = Paint();

  return ComputedParticle(
    renderer: (c, p) {
      c.drawCircle(
        Offset.zero,
        particleRadius * enterStayLeaveTween.transform(p.progress),
        paint..color = usedColorTween.transform(p.progress),
      );
    },
    lifespan: lifespan,
  );
}

/// Returns a new [Particle] which is
/// drawn as a line with [Gradient] stroke along
/// its direction. Slowly fades in and out.
Particle cometParticle({
  double radius = 2.0,
  double radiusVariation = .5,
  double lifespan = 1.0,
  Animatable<Color> colorTween,
  Offset position,
  Offset speed,
}) {
  Offset newPosition = position;
  Offset tailPosition = position;

  final paint = Paint()
    ..strokeWidth = radius
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  return ComputedParticle(
    renderer: (c, p) {
      newPosition += speed;
      tailPosition = newPosition + speed * -50;

      c.drawLine(
        newPosition,
        tailPosition,
        paint
          ..shader = Gradient.linear(newPosition, tailPosition, [
            smokeColorTween.transform(p.progress),
            Colors.white.withOpacity(0),
          ]),
      );
    },
    lifespan: lifespan,
  );
}
