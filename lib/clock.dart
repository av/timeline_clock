import 'dart:math';
import 'dart:ui';

import 'package:digital_clock/components/color_transition.dart';
import 'package:digital_clock/extensions/gradient_constructors.dart';
import 'package:digital_clock/extensions/offset_operations.dart';
import 'package:digital_clock/extensions/path_constructors.dart';
import 'package:digital_clock/extensions/random_utils.dart';
import 'package:digital_clock/extensions/rect_constructors.dart';
import 'package:digital_clock/extensions/canvas_operations.dart';
import 'package:digital_clock/resources/gradients.dart';
import 'package:digital_clock/resources/particles.dart';
import 'package:digital_clock/resources/tweens.dart';
import 'package:digital_clock/utils.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Gradient;

import 'package:digital_clock/extensions/date_time_progression.dart';
import 'package:digital_clock/extensions/path_offset_operations.dart';

class Clock extends BaseGame {
  /// Defines how many additional semi-transparent
  /// "timeline" paths would be rendered in addition
  /// to a main one
  static const ghostPaths = 3;
  static const ghostStart = 0.8;
  static const ghostStep = .1;

  /// Parameters of sparkle [Particle] which are visible during
  /// night hours
  static const sparkleSpeedRect = Rect.fromLTWH(0, -2, 2, 2);
  static const sparkleLifespan = 2.5;

  /// Used for time axises
  /// on top and the bottom
  static final scalePaint = Paint()
    ..color = Colors.white.withOpacity(.4)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 3.0;

  /// Used for path representing connection
  /// between hours/minutes/seconds
  static final timelinePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round
    ..color = Colors.white;

  /// Used for additional semi-transparent paths
  /// drawn near the main timeline
  static final ghostPathPaint = Paint()
    ..color = Colors.white10
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;

  /// Base paint for indcator shafts. Later is populated
  /// with [shader], when rendering.
  static final shaftPaint = Paint()
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

  /// Stores bounds of viewport after it's resized
  /// in logical pixels
  Rect bounds;
  Offset boundsHeight;

  /// Path to render for hours axis
  Path hoursScale;

  /// Path to render for minute axis
  Path minuteScale;

  /// Stores last and current timeline point positions
  /// Which are used to build smooth path between them.
  /// Additional store used to implement simple easing.
  List<Offset> actualPoints = [Offset.zero, Offset.zero, Offset.zero];
  List<Offset> drawnPoints = [Offset.zero, Offset.zero, Offset.zero];

  /// Time which clock will display. Updated in [update].
  DateTime now = DateTime.now();

  /// Render cycle, backroung and then clock UI on top
  /// particles are rendered with [BaseGame] [Component] hooks
  render(Canvas c) {
    renderBackground(c);
    c.renderScaled(
      renderer: renderTime,
      scale: const Offset(.8, .8),
      bounds: bounds,
    );

    super.render(c);
  }

  /// Computes current gradient as per time progression throughout the
  /// day and renders it across the whole viewport.
  void renderBackground(Canvas c) {
    final transitionIndex = now.dayProgress * skyboxGradients.length;
    final currentColorsIndex = transitionIndex.floor();
    final nextColorsIndex = transitionIndex.ceil() % skyboxGradients.length;
    final currentColorsProgress = transitionIndex - currentColorsIndex;

    c.drawRect(
      bounds,
      Paint()
        ..shader = GradientConstructors.fromColorTransition(
          transition: ColorTransition.lerp(
            skyboxGradients[currentColorsIndex],
            skyboxGradients[nextColorsIndex],
            currentColorsProgress,
          ),
          from: bounds.topLeft,
          to: bounds.bottomLeft,
        ),
    );
  }

  /// Renders timeline and time shafts
  /// for indicating the time to the user.
  void renderTime(Canvas c) {
    c.renderScaled(
      bounds: bounds,
      renderer: renderTimeline,
      scale: const Offset(1, .8),
    );

    renderTimeShafts(c);
    renderTimeAxises(c);
  }

  /// Renders main time "line". Builds a smooth [Path] between
  /// progression points as well as a few ghost paths.
  void renderTimeline(Canvas c) {
    final path = Path()..beziersTo(drawnPoints);

    c.drawPath(path, timelinePaint);

    final ghostPaths = List<Path>.generate(Clock.ghostPaths, (i) {
      return Path()
        ..beziersTo(
          drawnPoints,
          anchorMultiplier: ghostStart + ghostStep * i,
        );
    });

    for (final path in ghostPaths) {
      c.drawPath(path, ghostPathPaint);
    }
  }

  /// Draws [Path] of time axises. hours on top,
  /// minutes at the bottom.
  void renderTimeAxises(Canvas c) {
    c.drawPath(hoursScale, scalePaint);
    c.drawPath(minuteScale, scalePaint);
  }

  /// Renders a line from [Offset] to another [Offset]
  /// shading it with a linear [Gradient] described by given [ColorTrasnsition]
  void renderGradientLine(
    Canvas c,
    Offset from,
    Offset to,
    ColorTransition transition,
  ) {
    c.drawLine(
      from,
      to,
      shaftPaint
        ..shader = GradientConstructors.fromColorTransition(
          transition: transition,
          from: bounds.topLeft,
          to: bounds.bottomLeft,
        ),
    );
  }

  /// Renders time shafts for hours, minutes, seconds
  /// so it's easier to read the relatively precise value of the timeline
  void renderTimeShafts(Canvas c) {
    final hoursStart = Offset(now.dayProgress * bounds.width, 0);
    final hoursEnd = hoursStart + boundsHeight;

    renderGradientLine(c, hoursStart, hoursEnd, hoursShaft);

    final minutesStart = Offset(now.hourProgress * bounds.width, 0);
    final minutesEnd = minutesStart + boundsHeight;

    renderGradientLine(c, minutesStart, minutesEnd, minutesShaft);

    final secondsStart = Offset(now.minuteProgress * bounds.width, 0);
    final secondsEnd = secondsStart + boundsHeight;

    renderGradientLine(c, secondsStart, secondsEnd, secondsShaft);
  }

  @override
  void update(double t) {
    super.update(t);

    if (bounds != null) {
      updateTime();
      updateDrawnPoints();
      maybeSpawnParticles();
    }
  }

  /// Called by Flame, when viewport resizes.
  /// We reinstantiate all viewport-bound values here.
  void resize(Size size) {
    super.resize(size);

    bounds = Offset.zero & size;
    boundsHeight = Offset(0, bounds.height);

    hoursScale = PathConstructors.scale(
      bounds: Rect.fromPoints(
        bounds.topLeft,
        bounds.topRight + Offset(0, 10),
      ),
      ticks: 48,
      longerTicks: 12,
      secondaryTicks: 6,
      upwards: false,
      smallTickFactor: .1,
    );

    minuteScale = PathConstructors.scale(
      bounds: Rect.fromPoints(
        bounds.bottomLeft + Offset(0, -10),
        bounds.bottomRight,
      ),
      ticks: 60,
      longerTicks: 10,
      smallTickFactor: .2,
    );
  }

  /// Could be swapped with other update patterns
  /// for debugging/entertaining purposes.
  void updateTime() {
    now = DateTime.now();
  }

  /// Updates an array of anchor points to be used for the
  /// timeline to draw.
  void updateDrawnPoints() {
    final dayProgress = now.dayProgress;
    final progressions = <double>[
      dayProgress,
      now.hourProgress,
      now.minuteProgress,
    ];

    final expectedPoints = List<Offset>.generate(
      progressions.length,
      (i) => Offset(
        progressions[i] * bounds.width,
        (i / (progressions.length - 1)) * bounds.height,
      ),
    );

    drawnPoints = List<Offset>.generate(expectedPoints.length, (i) {
      return Offset.lerp(actualPoints[i], expectedPoints[i], .1);
    });

    actualPoints = drawnPoints;
  }

  /// When called, spawns [Particle] and adds them to [BaseGame]
  /// when necessary.
  void maybeSpawnParticles() {
    if (bounds == null) return;

    /// Only spawn if probability of
    /// having stars this time of the day allows it
    if (rnd.nextDouble() > starSpawnProbabilityTween.transform(now.dayProgress))
      return;

    final position = OffsetOperations.randomInRect(bounds);
    final particle = rnd.nextDouble() > .01
        ? sparkleParticle(lifespan: sparkleLifespan)
            .accelerated(
              position: position,
              speed: OffsetOperations.randomInRect(sparkleSpeedRect),
            )
            .asComponent()
        : cometParticle(
            position: position,
            speed: Offset.fromDirection(rnd.doubleBetween(pi, pi * 2), 2),
          ).asComponent();

    add(particle);
  }

  @override
  backgroundColor() => Colors.blueGrey.shade900;
}
