/// Supported, user-selectable interface languages.
///
/// A pure-domain value object: no Flutter, serialization, or infrastructure
/// types cross into it. The presentation and persistence layers translate this
/// to a `Locale` / storage token inside their own boundaries.
enum AppLanguage {
  /// English (`en`).
  english('en'),

  /// Spanish (`es`) — the product's default interface language, matching the
  /// approved HR/payment mockups and the `S/.` currency locale.
  spanish('es');

  /// Binds each language to its ISO-639 language code.
  const AppLanguage(this.code);

  /// ISO-639 language code (e.g. `en`, `es`).
  final String code;

  /// The product-wide default applied when no preference has been persisted.
  static const AppLanguage fallback = AppLanguage.spanish;

  /// Resolves an [AppLanguage] from a stored [code], or `null` when unknown.
  ///
  /// Total by construction: an unrecognized or `null` code yields `null`, letting
  /// callers fall back to [fallback] rather than throwing.
  static AppLanguage? fromCode(String? code) {
    for (final AppLanguage language in AppLanguage.values) {
      if (language.code == code) return language;
    }
    return null;
  }
}
