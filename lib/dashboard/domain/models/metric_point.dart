/// Immutable single sample of a chronological workforce metric series.
///
/// Each point maps a moment in time ([date]) to a scalar [value] plotted by the
/// historical progress line chart. Pure by construction — it carries no
/// serialization or infrastructure concerns.
class MetricPoint {
  /// Creates an immutable [MetricPoint].
  const MetricPoint({
    required this.date,
    required this.value,
  });

  /// Instant this sample corresponds to on the chart's horizontal axis.
  final DateTime date;

  /// Scalar magnitude of the metric at [date] on the chart's vertical axis.
  final double value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MetricPoint && other.date == date && other.value == value;
  }

  @override
  int get hashCode => Object.hash(date, value);

  @override
  String toString() => 'MetricPoint(date: $date, value: $value)';
}
