import 'package:flutter/material.dart';

import '../../../shared/presentation/components/status_screen.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../components/success_check_mark.dart';

/// "Session Started" success interstitial shown after a successful login.
///
/// Reuses the shared [StatusScreen] layout with the IAM [SuccessCheckMark] and
/// localized copy. Stateless and free of any bloc — a terminal confirmation
/// screen driven entirely by navigation.
class SessionStartedView extends StatelessWidget {
  /// Creates a [SessionStartedView].
  const SessionStartedView({super.key, required this.onContinue});

  /// Invoked when the primary "Continue" CTA is pressed.
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      icon: const SuccessCheckMark(),
      statusLabel: AppStrings.sessionStarted,
      ctaLabel: AppStrings.continueLabel,
      onCta: onContinue,
    );
  }
}
