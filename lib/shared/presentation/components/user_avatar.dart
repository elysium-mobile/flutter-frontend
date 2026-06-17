import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../design/app_typography.dart';

/// Circular user avatar atom rendering the initials derived from a display name.
///
/// Used by the dashboard and profile screens. The circle is filled with the
/// brand gradient and announced to assistive technologies via its [name].
class UserAvatar extends StatelessWidget {
  /// Creates a [UserAvatar].
  const UserAvatar({super.key, required this.name, this.diameter = 88});

  /// Display name from which the initials are computed.
  final String name;

  /// Outer diameter of the avatar (a perfect circle, radius 50%).
  final double diameter;

  /// Computes up to two uppercase initials from [name].
  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return letters.isEmpty ? '?' : letters;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: name,
      image: true,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryButton,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          _initials,
          style: AppTypography.title.copyWith(
            color: AppColors.accentWhite,
            fontSize: diameter * 0.34,
          ),
        ),
      ),
    );
  }
}
