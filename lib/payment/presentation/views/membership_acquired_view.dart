import 'package:flutter/material.dart';

import '../../../shared/presentation/components/status_screen.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/i18n/app_strings.dart';

/// "Membresía adquirida" transaction-success screen — Screen 4.
///
/// Reuses the shared [StatusScreen] layout (brand logo, centered indicator, bold
/// status label, single bottom CTA) with a navy checkmark glyph. The "Menú
/// inicial" CTA is wired by the router to reset the stack to the authenticated
/// initial menu.
class MembershipAcquiredView extends StatelessWidget {
  /// Creates a [MembershipAcquiredView].
  const MembershipAcquiredView({super.key, required this.onContinue});

  /// Invoked when the "Menú inicial" CTA is pressed.
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      icon: const _NavyCheckMark(),
      statusLabel: AppStrings.membershipAcquired,
      ctaLabel: AppStrings.initialMenu,
      onCta: onContinue,
    );
  }
}

/// Large solid navy blue checkmark glyph denoting a successful transaction.
class _NavyCheckMark extends StatelessWidget {
  const _NavyCheckMark();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Success',
      image: true,
      child: const Icon(
        Icons.check_rounded,
        size: 120,
        color: AppColors.primaryNavy,
      ),
    );
  }
}
