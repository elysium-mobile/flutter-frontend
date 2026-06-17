import 'package:flutter/material.dart';

import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';

/// Small semantic badge displaying "✓ Verified domain" next to the corporate
/// email field once the entered address satisfies the corporate-domain policy.
///
/// Styled as a chip ([AppRadii.chip]) tinted with the semantic success color and
/// announced to assistive technologies as a status. Its label is localized.
class VerifiedDomainBadge extends StatelessWidget {
  /// Creates a [VerifiedDomainBadge].
  const VerifiedDomainBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppStrings.verifiedDomain,
      container: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadii.chip),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.check_circle_rounded,
              size: 14,
              color: AppColors.success,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              AppStrings.verifiedDomain,
              style: AppTypography.caption.copyWith(color: AppColors.success),
            ),
          ],
        ),
      ),
    );
  }
}
