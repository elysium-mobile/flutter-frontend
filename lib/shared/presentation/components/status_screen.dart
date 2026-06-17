import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../design/app_dimensions.dart';
import '../design/app_typography.dart';
import 'app_logo.dart';
import 'gradient_button.dart';

/// Reusable, high-contrast centered confirmation layout.
///
/// Composition: top branding logo, a caller-provided [icon] (e.g. a success
/// check mark), a bold centered [statusLabel] and a single bottom-anchored
/// primary CTA. Shared by every interstitial so the layout is defined once.
class StatusScreen extends StatelessWidget {
  /// Creates a [StatusScreen].
  const StatusScreen({
    super.key,
    required this.icon,
    required this.statusLabel,
    required this.ctaLabel,
    required this.onCta,
  });

  /// The large centered status illustration (e.g. a success check mark).
  final Widget icon;

  /// Bold status notification rendered below the [icon].
  final String statusLabel;

  /// Caption of the single bottom CTA.
  final String ctaLabel;

  /// Invoked when the CTA is pressed.
  final VoidCallback onCta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: AppSpacing.md),
              const AppLogo(compact: true),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    icon,
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      statusLabel,
                      textAlign: TextAlign.center,
                      style: AppTypography.displayLarge,
                    ),
                  ],
                ),
              ),
              GradientButton(label: ctaLabel, onPressed: onCta),
            ],
          ),
        ),
      ),
    );
  }
}
