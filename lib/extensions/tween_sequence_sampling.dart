import 'package:flutter/animation.dart';

extension SequenceSampling<E> on TweenSequence<E> {
  /// Returns a list of samples from current [TweenSequence]
  /// taken with linear step, as per requested samples count.
  List<E> sample({int samples = 10}) {
    return List<E>.generate(samples, (i) => transform(i / samples));
  }
}
