import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../design/app_dimensions.dart';
import '../design/app_typography.dart';

/// Outlined secondary call-to-action button atom.
///
/// Mirrors the primary button height/radius but renders as an outlined Navy
/// surface, used for secondary actions such as "Edit Profile" and "Back".
class OutlinedActionButton extends StatelessWidget {
  /// Creates an [OutlinedActionButton].
  const OutlinedActionButton({
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
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryNavy,
          side: const BorderSide(color: AppColors.primaryNavy),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(color: AppColors.primaryNavy),
        ),
      ),
    );
  }
}
