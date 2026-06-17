/// Spacing tokens derived from the documented 8px grid baseline.
abstract final class AppSpacing {
  /// Half-step (4px).
  static const double xxs = 4;

  /// One grid unit (8px).
  static const double xs = 8;

  /// Two grid units (16px).
  static const double sm = 16;

  /// Three grid units (24px).
  static const double md = 24;

  /// Four grid units (32px).
  static const double lg = 32;

  /// Six grid units (48px).
  static const double xl = 48;
}

/// Corner-radius tokens (in logical pixels).
abstract final class AppRadii {
  /// Card radius (16px).
  static const double card = 16;

  /// Button radius (12px).
  static const double button = 12;

  /// Input field radius (12px).
  static const double input = 12;

  /// Chip / tag radius (20px).
  static const double chip = 20;
}

/// Fixed component dimensions taken from the component specification.
abstract final class AppSizes {
  /// Height of the employee primary button (52px).
  static const double primaryButtonHeight = 52;

  /// Height of an input field (52px).
  static const double inputHeight = 52;

  /// Stroke width of the focused input border (1px).
  static const double focusedBorderWidth = 1;
}
