import 'package:flutter/material.dart';

import '../../../shared/presentation/design/app_colors.dart';

/// Large semantic success check mark used by the IAM success interstitials.
///
/// Rendered as a circular success-tinted surface with a centered check icon and
/// announced as a status image to assistive technologies.
class SuccessCheckMark extends StatelessWidget {
  /// Creates a [SuccessCheckMark].
  const SuccessCheckMark({super.key, this.diameter = 96});

  /// Outer diameter of the badge, in logical pixels.
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Success',
      image: true,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: diameter * 0.62,
          height: diameter * 0.62,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: AppColors.accentWhite,
            size: diameter * 0.38,
          ),
        ),
      ),
    );
  }
}
