import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../design/app_dimensions.dart';
import '../design/app_typography.dart';

/// Employee primary call-to-action button atom.
///
/// Implements the documented spec: a full-width control of
/// [AppSizes.primaryButtonHeight] height filled with the horizontal
/// [AppGradients.primaryButton] (Sky → Teal), rounded to [AppRadii.button].
/// Shows a progress indicator when [isLoading]; renders dimmed/disabled when
/// [onPressed] is `null`.
class GradientButton extends StatelessWidget {
  /// Creates a [GradientButton].
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  /// Button caption.
  final String label;

  /// Tap handler. When `null`, the button is disabled.
  final VoidCallback? onPressed;

  /// Whether to show an in-progress indicator instead of the [label].
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: SizedBox(
          width: double.infinity,
          height: AppSizes.primaryButtonHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.primaryButton,
              borderRadius: BorderRadius.circular(AppRadii.button),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadii.button),
                onTap: isEnabled ? onPressed : null,
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.accentWhite,
                            ),
                          ),
                        )
                      : Text(
                          label,
                          style: AppTypography.label.copyWith(
                            color: AppColors.accentWhite,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
