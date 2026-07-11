import 'package:flutter/material.dart';

import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../domain/models/forum_thread.dart';

/// Reusable card summarizing a [ForumThread].
///
/// Renders the thread title, the raw ISO timestamp, a static red flag (report)
/// glyph representing structural metadata, and the message-count bubble. Shared
/// by the thread list (tappable) and the conversation header (static, [onTap]
/// null). Purely presentational and read-only — it exposes no reply affordance.
class ForumThreadCard extends StatelessWidget {
  /// Creates a [ForumThreadCard].
  const ForumThreadCard({super.key, required this.thread, this.onTap});

  /// The thread to summarize.
  final ForumThread thread;

  /// Optional tap handler; when null the card is a static header.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryNavy.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  thread.title,
                  style: AppTypography.label.copyWith(
                    color: AppColors.primaryNavy,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              // Static structural-metadata flag (report marker); non-interactive.
              const Icon(Icons.flag_rounded, color: AppColors.danger, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  thread.timestamp,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.dark.withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 16,
                color: AppColors.dark.withValues(alpha: 0.5),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${thread.messageCount}',
                style: AppTypography.caption.copyWith(
                  color: AppColors.dark.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.card),
        onTap: onTap,
        child: card,
      ),
    );
  }
}
