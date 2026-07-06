part of 'locale_bloc.dart';

/// Immutable state exposing the active interface [language] to the app shell.
final class LocaleState extends Equatable {
  /// Creates a [LocaleState] for [language].
  const LocaleState(this.language);

  /// The currently active interface language.
  final AppLanguage language;

  /// The Flutter [Locale] mirroring [language], for `MaterialApp.locale`.
  Locale get locale => Locale(language.code);

  @override
  List<Object?> get props => <Object?>[language];
}
