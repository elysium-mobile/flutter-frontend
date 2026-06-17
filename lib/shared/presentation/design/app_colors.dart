import 'package:flutter/widgets.dart';

/// SoftWork color palette, transcribed verbatim from the design specification.
///
/// Only documented values are encoded; no color is inferred. Every widget
/// references these tokens instead of hard-coding literals.
abstract final class AppColors {
  /// Primary brand color — Navy.
  static const Color primaryNavy = Color(0xFF1C4B78);

  /// Secondary brand color — Sky.
  static const Color sky = Color(0xFF4DA8DA);

  /// Tertiary brand color — Teal.
  static const Color teal = Color(0xFF19A4A1);

  /// Accent surface color — White.
  static const Color accentWhite = Color(0xFFF2F4F7);

  /// Neutral dark color, used for primary text.
  static const Color dark = Color(0xFF3E3E3E);

  /// Accent color — Mint (resting input border).
  static const Color mint = Color(0xFFA5E3D8);

  /// Semantic success color.
  static const Color success = Color(0xFF19A4A1);

  /// Semantic danger color.
  static const Color danger = Color(0xFFC94040);

  /// Plain white surface.
  static const Color surface = Color(0xFFFFFFFF);
}

/// Gradient tokens defined by the component specification.
abstract final class AppGradients {
  /// Horizontal gradient (Sky → Teal) used by the employee primary button.
  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[AppColors.sky, AppColors.teal],
  );

  /// Horizontal gradient (Mint → Sky) used by the focused input border.
  static const LinearGradient focusedInputBorder = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[AppColors.mint, AppColors.sky],
  );
}
