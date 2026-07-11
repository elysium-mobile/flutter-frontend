/// Deterministic workplace-climate verdict returned by the AI dashboard
/// assistant.
///
/// The label is computed server-side from metric thresholds (not by the AI
/// model) and arrives as one of the wire tokens `"BUENO"`, `"REGULAR"` or
/// `"CRITICO"`. [ClimateStatus.unknown] is the total fallback for any
/// unrecognized or empty token, so the presentation layer never has to handle a
/// missing case.
enum ClimateStatus {
  /// Healthy climate (`"BUENO"`).
  good,

  /// Acceptable but non-optimal climate (`"REGULAR"`).
  regular,

  /// Critical climate requiring intervention (`"CRITICO"`).
  critical,

  /// Unrecognized or absent status token.
  unknown;

  /// Maps a raw backend status token onto a [ClimateStatus].
  ///
  /// The comparison is case-insensitive and trims surrounding whitespace; any
  /// token outside the documented set resolves to [ClimateStatus.unknown]
  /// rather than throwing, keeping deserialization total.
  static ClimateStatus fromWire(String token) {
    switch (token.trim().toUpperCase()) {
      case 'BUENO':
        return ClimateStatus.good;
      case 'REGULAR':
        return ClimateStatus.regular;
      case 'CRITICO':
      case 'CRÍTICO':
        return ClimateStatus.critical;
      default:
        return ClimateStatus.unknown;
    }
  }
}
