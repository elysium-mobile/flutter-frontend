import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../design/app_dimensions.dart';
import '../design/app_typography.dart';

/// Central "SoftWork" brand lockup reused across authentication screens and
/// success interstitials.
///
/// Rendered with framework primitives (no external asset assumed beyond the
/// bundled Exo family) and exposed to assistive technologies as a single
/// labeled image.
class AppLogo extends StatelessWidget {
  /// Creates an [AppLogo].
  const AppLogo({super.key, this.compact = false});

  /// When `true`, renders a smaller variant suitable for dense headers.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double glyphSize = compact ? 40 : 56;
    final double wordSize = compact ? 22 : 28;

    return Semantics(
      label: 'SoftWork',
      image: true,
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: glyphSize,
            height: glyphSize,
            decoration: const BoxDecoration(
              gradient: AppGradients.primaryButton,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.hub_rounded,
              color: AppColors.accentWhite,
              size: glyphSize * 0.55,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Soft',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: wordSize,
                    color: AppColors.primaryNavy,
                  ),
                ),
                TextSpan(
                  text: 'Work',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: wordSize,
                    color: AppColors.teal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
