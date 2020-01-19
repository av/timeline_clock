/// Adds a notion of unit progress to [DateTime].
extension DateTimeProgression on DateTime {
  /// [double] between 0..1, representing how much
  /// of a current second have already passed
  double get secondProgress {
    return this.millisecond / 1000;
  }

  /// [double] between 0..1, representing how much
  /// of a current minute have already passed
  double get minuteProgress {
    return (this.second / 60) + (secondProgress / 60);
  }

  /// [double] between 0..1, representing how much
  /// of a current hour have already passed
  double get hourProgress {
    return (this.minute / 60) + (minuteProgress / 60);
  }

  /// [double] between 0..1, representing how much
  /// of a current day have already passed
  double get dayProgress {
    return (this.hour / 24) + (hourProgress / 24);
  }
}
