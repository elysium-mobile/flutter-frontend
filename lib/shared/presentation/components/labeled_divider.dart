import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../design/app_dimensions.dart';
import '../design/app_typography.dart';

/// Horizontal divider with an integrated centered character.
///
/// Used between the primary action and the federated sign-in button; the caller
/// supplies the [label] (the lowercase "o" in the login mockup).
class LabeledDivider extends StatelessWidget {
  /// Creates a [LabeledDivider].
  const LabeledDivider({super.key, required this.label});

  /// The character rendered at the center of the divider.
  final String label;

  @override
  Widget build(BuildContext context) {
    final Color lineColor = AppColors.dark.withValues(alpha: 0.15);

    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: lineColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            label,
            style: AppTypography.body.copyWith(
              color: AppColors.dark.withValues(alpha: 0.6),
            ),
          ),
        ),
        Expanded(child: Divider(color: lineColor, thickness: 1)),
      ],
    );
  }
}
