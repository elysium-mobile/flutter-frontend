import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart' show Locale;

import '../../domain/models/app_language.dart';
import '../../domain/stores/locale_store.dart';

part 'locale_event.dart';
part 'locale_state.dart';

/// Long-lived state machine owning the active interface language.
///
/// It is the single reactive source of truth for runtime localization: the
/// `MaterialApp` builder listens to this bloc to drive `MaterialApp.locale` (and
/// mirror the value into [AppLocale]), while the Profile language selector reads
/// [LocaleState.language] for its current selection and dispatches
/// [LocaleSelected] to switch languages.
///
/// Layer purity: this bloc depends only on the [LocaleStore] port and the pure
/// [AppLanguage] domain value — never on the presentation `AppLocale` holder, so
/// the inward dependency direction is preserved. Applying the language to the
/// process-wide holder is the presentation layer's responsibility.
///
/// Like [SessionBloc], it is a long-lived singleton provided above
/// `MaterialApp.router` via `BlocProvider.value`.
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  /// Creates a [LocaleBloc] bound to the [LocaleStore] persistence port.
  LocaleBloc({required LocaleStore localeStore})
      : _localeStore = localeStore, // ignore: prefer_initializing_formals
        super(const LocaleState(AppLanguage.fallback)) {
    on<LocaleInitialized>(_onInitialized);
    on<LocaleSelected>(_onSelected);
  }

  final LocaleStore _localeStore;

  /// Hydrates the active language from the persisted preference on bootstrap,
  /// falling back to [AppLanguage.fallback] when none was ever stored.
  Future<void> _onInitialized(
    LocaleInitialized event,
    Emitter<LocaleState> emit,
  ) async {
    final AppLanguage stored =
        await _localeStore.readLanguage() ?? AppLanguage.fallback;
    emit(LocaleState(stored));
  }

  /// Switches to the selected language and persists it.
  ///
  /// Selecting the already-active language is a no-op, so no redundant state
  /// emission (and therefore no redundant `MaterialApp` locale rebuild) occurs.
  Future<void> _onSelected(
    LocaleSelected event,
    Emitter<LocaleState> emit,
  ) async {
    if (event.language == state.language) return;
    emit(LocaleState(event.language));
    await _localeStore.writeLanguage(event.language);
  }
}
