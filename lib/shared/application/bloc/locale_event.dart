part of 'locale_bloc.dart';

/// Base type for every intent processed by [LocaleBloc].
sealed class LocaleEvent extends Equatable {
  /// Const constructor for subclasses.
  const LocaleEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// Bootstrap intent requesting hydration of the persisted language preference.
final class LocaleInitialized extends LocaleEvent {
  /// Creates a [LocaleInitialized].
  const LocaleInitialized();
}

/// Public intent requesting a switch to [language] (e.g. from the Profile tab).
final class LocaleSelected extends LocaleEvent {
  /// Creates a [LocaleSelected] carrying the newly chosen [language].
  const LocaleSelected(this.language);

  /// The language the user selected.
  final AppLanguage language;

  @override
  List<Object?> get props => <Object?>[language];
}
