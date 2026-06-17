import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../design/app_dimensions.dart';
import '../design/app_typography.dart';

/// Reusable SoftWork input field atom.
///
/// Encodes the documented input tokens: [AppColors.accentWhite] background,
/// [AppSizes.inputHeight] height, [AppRadii.input] corner radius and a 1px
/// focused border. As Flutter's [OutlineInputBorder] cannot paint a gradient
/// stroke, the documented Mint→Sky focus gradient is represented by its Mint
/// (resting) and Sky (focused) endpoints with a consistent 1px stroke; no
/// undocumented value is introduced.
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField].
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.prefixIcon,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
  });

  /// Field label rendered above the input. Pass an empty string to omit it.
  final String label;

  /// Controller backing the editable text.
  final TextEditingController controller;

  /// Optional placeholder shown when the field is empty.
  final String? hintText;

  /// Optional keyboard configuration (e.g. email address).
  final TextInputType? keyboardType;

  /// Whether the field hides its characters (passwords).
  final bool obscureText;

  /// Optional keyboard action button behavior.
  final TextInputAction? textInputAction;

  /// Optional leading icon.
  final Widget? prefixIcon;

  /// Optional trailing widget (e.g. the password visibility toggle).
  final Widget? suffix;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits from the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Optional inline validation message.
  final String? errorText;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.input),
        borderSide: BorderSide(
          color: color,
          width: AppSizes.focusedBorderWidth,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label.isNotEmpty) ...<Widget>[
          Text(label, style: AppTypography.label),
          const SizedBox(height: AppSpacing.xs),
        ],
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.inputHeight),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: AppTypography.input,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.accentWhite,
              hintText: hintText,
              hintStyle: AppTypography.input.copyWith(
                color: AppColors.dark.withValues(alpha: 0.4),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffix,
              errorText: errorText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              enabledBorder: _border(AppColors.mint),
              focusedBorder: _border(AppColors.sky),
              errorBorder: _border(AppColors.danger),
              focusedErrorBorder: _border(AppColors.danger),
            ),
          ),
        ),
      ],
    );
  }
}
