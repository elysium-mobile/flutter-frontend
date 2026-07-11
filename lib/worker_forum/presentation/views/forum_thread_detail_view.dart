import 'package:flutter/material.dart';

import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../domain/models/forum_message.dart';
import '../../domain/models/forum_thread.dart';
import '../components/forum_thread_card.dart';

/// Screen 2 — Worker Forum thread conversation (RRHH read-only).
///
/// Shows the thread header card, a "Replies" sub-header, and the vertical stream
/// of anonymous message blocks. There is deliberately **no** comment input bar
/// and **no** send button: the RRHH user is an observer and cannot post replies.
class ForumThreadDetailView extends StatelessWidget {
  /// Creates a [ForumThreadDetailView] for [thread].
  const ForumThreadDetailView({super.key, required this.thread});

  /// The thread to display, carrying its nested messages.
  final ForumThread thread;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        // Default leading back arrow returns to the thread list.
        title: Text(AppStrings.forumTitle, style: AppTypography.title),
      ),
      // No bottom comment bar / send button: replying is not an RRHH capability.
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ForumThreadCard(thread: thread),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.forumReplies,
              style: AppTypography.caption.copyWith(
                color: AppColors.dark.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final ForumMessage message in thread.messages) ...<Widget>[
              _MessageBlock(message: message),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

/// A single anonymous message block: "User #N" header + message content.
class _MessageBlock extends StatelessWidget {
  const _MessageBlock({required this.message});

  final ForumMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.accentWhite,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${AppStrings.forumUserPrefix} #${message.userAccountId}',
            style: AppTypography.caption.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: AppTypography.semiBold,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(message.content, style: AppTypography.body),
        ],
      ),
    );
  }
}
