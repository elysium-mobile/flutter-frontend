import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, rootBundle;

import 'app_colors.dart';
import 'app_typography.dart';

/// Central builder for the application's root [ThemeData] and the code-only
/// registrar of the `Exo` font family.
///
/// Enforces the SoftWork design language globally: the `Exo` family is applied
/// across every semantic text property, the palette is anchored on the brand
/// tokens, and surfaces default to white. The family is registered purely from
/// Dart (via [ensureFontsLoaded]) against the bundled font assets, with an
/// on-device fallback chain — no runtime font network request is performed,
/// keeping startup safe in offline environments.
abstract final class AppTheme {
  /// Bundled `Exo` font asset paths registered under the [AppTypography]
  /// family at runtime.
  ///
  /// The engine reads each file's embedded weight/style metadata, so requests
  /// for [FontWeight.w400]–[FontWeight.w800] (and italic) resolve to the
  /// matching face without per-asset descriptors.
  ///
  /// NOTE: Flutter's text engine supports only `.ttf`/`.otf`/`.ttc` — not
  /// `.woff2`. These paths must point at TrueType/OpenType files, and
  /// `assets/fonts/` must be declared under `flutter: assets:` in `pubspec.yaml`
  /// so the bytes are bundled and reachable through [rootBundle].
  static const List<String> _exoFontAssets = <String>[
    'assets/fonts/exo-regular.ttf',
    'assets/fonts/exo-medium.ttf',
    'assets/fonts/exo-semibold.ttf',
    'assets/fonts/exo-bold.ttf',
    'assets/fonts/exo-extrabold.ttf',
    'assets/fonts/exo-italic.ttf',
  ];

  /// Registers the `Exo` family from the bundled assets, purely in Dart.
  ///
  /// Invoke once during bootstrap, after `WidgetsFlutterBinding.ensureInitialized`
  /// and before `runApp`. Failures (missing or unsupported font files) are
  /// caught and logged so they never block startup — text simply falls back to
  /// [AppTypography.fontFamilyFallback] until valid assets are present.
  static Future<void> ensureFontsLoaded() async {
    try {
      final loader = FontLoader(AppTypography.fontFamily);
      for (final assetPath in _exoFontAssets) {
        loader.addFont(rootBundle.load(assetPath));
      }
      await loader.load();
    } catch (error, stackTrace) {
      developer.log(
        'Failed to load the Exo font family; falling back to system fonts. '
        'Ensure assets/fonts holds .ttf/.otf files and is declared under '
        'flutter: assets: in pubspec.yaml.',
        name: 'AppTheme',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Builds the light [ThemeData] used as the application root theme.
  static ThemeData light() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryNavy,
      primary: AppColors.primaryNavy,
      secondary: AppColors.teal,
      surface: AppColors.surface,
    );

    final ThemeData base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: AppTypography.fontFamily,
      fontFamilyFallback: AppTypography.fontFamilyFallback,
    );

    return base.copyWith(
      textTheme: _applyExo(base.textTheme),
      primaryTextTheme: _applyExo(base.primaryTextTheme),
      appBarTheme: _appBarTheme(),
    );
  }

  /// Reapplies the Exo family (and its fallbacks) to every entry of [textTheme].
  ///
  /// `ThemeData.fontFamily` already seeds the default, but applying it to the
  /// resolved [TextTheme] guarantees no Material default style slips through with
  /// a platform font.
  static TextTheme _applyExo(TextTheme textTheme) {
    return textTheme.apply(
      fontFamily: AppTypography.fontFamily,
      fontFamilyFallback: AppTypography.fontFamilyFallback,
      bodyColor: AppColors.dark,
      displayColor: AppColors.dark,
    );
  }

  /// App bar theme aligned with the brand palette and Exo title style.
  static AppBarTheme _appBarTheme() {
    return AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primaryNavy,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.title,
    );
  }
}
