import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Typography tokens built on the Exo type family.
///
/// `Exo` is provided as the bundled application font family (configured in the
/// read-only asset/pubspec setup), so styles reference it through [fontFamily]
/// rather than via a runtime font package. All documented Exo weights are
/// exposed as named constants.
abstract final class AppTypography {
  /// The bundled font family name.
  static const String fontFamily = 'Exo';

  /// Ordered fallback families used when an `Exo` glyph is unavailable.
  ///
  /// Resolved entirely from on-device fonts, so text rendering never depends on
  /// a network request and remains safe in fully offline environments.
  static const List<String> fontFamilyFallback = <String>['Roboto', 'Arial'];

  /// Display weight (800).
  static const FontWeight display = FontWeight.w800;

  /// Bold weight (700).
  static const FontWeight bold = FontWeight.w700;

  /// SemiBold weight (600).
  static const FontWeight semiBold = FontWeight.w600;

  /// Medium weight (500).
  static const FontWeight medium = FontWeight.w500;

  /// Regular weight (400).
  static const FontWeight regular = FontWeight.w400;

  /// Light weight (300).
  static const FontWeight light = FontWeight.w300;

  /// Builds an Exo [TextStyle] with the supplied attributes.
  static TextStyle _exo({
    required double fontSize,
    required FontWeight fontWeight,
    Color color = AppColors.dark,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  /// Large branding / interstitial heading (Display 800).
  static TextStyle get displayLarge =>
      _exo(fontSize: 28, fontWeight: display, color: AppColors.primaryNavy);

  /// Screen title (Bold 700).
  static TextStyle get title =>
      _exo(fontSize: 22, fontWeight: bold, color: AppColors.primaryNavy);

  /// Section / button label (SemiBold 600).
  static TextStyle get label => _exo(fontSize: 16, fontWeight: semiBold);

  /// Body copy (Regular 400).
  static TextStyle get body => _exo(fontSize: 14, fontWeight: regular);

  /// Subtitle / helper (Light 300).
  static TextStyle get subtitle => _exo(fontSize: 13, fontWeight: light);

  /// Input field text (Regular 400).
  static TextStyle get input =>
      _exo(fontSize: 15, fontWeight: regular, color: AppColors.dark);

  /// Badge / chip caption (Medium 500).
  static TextStyle get caption => _exo(fontSize: 12, fontWeight: medium);
}
