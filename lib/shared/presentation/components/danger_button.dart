import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../design/app_dimensions.dart';
import '../design/app_typography.dart';

/// Critical (destructive) action button atom, filled with the semantic danger
/// color. Used for irreversible actions such as "Sign Out".
class DangerButton extends StatelessWidget {
  /// Creates a [DangerButton].
  const DangerButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  /// Button caption.
  final String label;

  /// Tap handler. When `null`, the button is disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.primaryButtonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.danger,
          foregroundColor: AppColors.accentWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(color: AppColors.accentWhite),
        ),
      ),
    );
  }
}
