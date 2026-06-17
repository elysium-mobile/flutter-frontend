import 'package:flutter/material.dart';

import '../../../shared/presentation/components/status_screen.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../components/success_check_mark.dart';

/// "User Registered" success interstitial shown after a successful registration.
///
/// Reuses the shared [StatusScreen] layout, differing only in copy: a
/// "User Registered" status and a primary "Sign In" CTA that routes the new
/// employee back to the login flow.
class UserRegisteredView extends StatelessWidget {
  /// Creates a [UserRegisteredView].
  const UserRegisteredView({super.key, required this.onSignIn});

  /// Invoked when the primary "Sign In" CTA is pressed.
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      icon: const SuccessCheckMark(),
      statusLabel: AppStrings.userRegistered,
      ctaLabel: AppStrings.signIn,
      onCta: onSignIn,
    );
  }
}
