import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../design/app_dimensions.dart';
import '../design/app_typography.dart';

/// Full-width outlined "Continue with Google" button atom.
///
/// Matches the documented button height/radius but is rendered as an outlined
/// surface to differentiate the federated action from the primary gradient CTA.
/// The Google brand mark is drawn from framework primitives so no external asset
/// path needs to be assumed.
class GoogleSignInButton extends StatelessWidget {
  /// Creates a [GoogleSignInButton].
  const GoogleSignInButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  /// Button caption.
  final String label;

  /// Tap handler. When `null`, the button is disabled.
  final VoidCallback? onPressed;

  /// Whether an in-progress indicator replaces the brand glyph.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    return Opacity(
      opacity: isEnabled ? 1 : 0.5,
      child: SizedBox(
        width: double.infinity,
        height: AppSizes.inputHeight,
        child: OutlinedButton.icon(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.accentWhite,
            side: BorderSide(color: AppColors.dark.withValues(alpha: 0.12)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.button),
            ),
          ),
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : const _GoogleGlyph(),
          label: Text(
            label,
            style: AppTypography.label.copyWith(color: AppColors.dark),
          ),
        ),
      ),
    );
  }
}

/// Compact representation of the Google "G" brand mark.
class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Text(
        'G',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 18,
          fontWeight: AppTypography.bold,
          color: AppColors.sky,
        ),
      ),
    );
  }
}
