import 'package:flutter/widgets.dart';

import '../../domain/models/app_language.dart';

/// Process-wide holder of the active interface language and the single string
/// resolver consumed by [AppStrings].
///
/// The one mutable field, [current], is the source the static `AppStrings`
/// getters read. It is assigned exactly once per locale change by the
/// presentation layer (the `MaterialApp` builder that reacts to `LocaleBloc`)
/// immediately before `MaterialApp` rebuilds its `Localizations` subtree, so
/// every string re-resolved during that rebuild reflects the new language.
///
/// This indirection is deliberate: it lets the entire view layer keep calling
/// `AppStrings.x` with no `BuildContext` plumbing while still switching languages
/// at runtime. It is written only from the reactive `LocaleBloc` boundary — never
/// mutate it ad hoc from a view.
abstract final class AppLocale {
  /// The currently active interface language.
  ///
  /// Seeded with [AppLanguage.fallback] and overwritten once the persisted
  /// preference resolves during bootstrap.
  static AppLanguage current = AppLanguage.fallback;

  /// The Flutter [Locale] mirroring [current], for `MaterialApp.locale`.
  static Locale get locale => Locale(current.code);

  /// Resolves a per-language literal for the active [current] language.
  ///
  /// Every user-facing string routes through this one lookup, so translations
  /// live in a single place and adding a language becomes a mechanical, total
  /// change (the `switch` stops compiling until every case is handled).
  static String t({required String en, required String es}) {
    switch (current) {
      case AppLanguage.english:
        return en;
      case AppLanguage.spanish:
        return es;
    }
  }
}
