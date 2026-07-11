import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../application/bloc/forum_bloc.dart';
import '../../domain/models/forum_thread.dart';
import '../components/forum_thread_card.dart';
import '../navigation/forum_routes.dart';

/// Screen 1 — Worker Forum thread list (RRHH read-only).
///
/// Lists the company-scoped active threads under the "Forum" header. Each entry
/// is a [ForumThreadCard] that opens the conversation view. There is
/// deliberately **no** floating action button: the RRHH user is an observer and
/// cannot create threads.
class ForumThreadListView extends StatelessWidget {
  /// Creates a [ForumThreadListView].
  const ForumThreadListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(AppStrings.forumTitle, style: AppTypography.title),
      ),
      // No floatingActionButton: creating threads is not an RRHH capability.
      body: BlocBuilder<ForumBloc, ForumState>(
        builder: (BuildContext context, ForumState state) {
          switch (state.status) {
            case ForumStatus.initial:
            case ForumStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ForumStatus.failure:
              return _CenteredMessage(text: AppStrings.somethingWentWrong);
            case ForumStatus.ready:
              if (state.threads.isEmpty) {
                return _CenteredMessage(text: AppStrings.forumEmpty);
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                itemCount: state.threads.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (BuildContext context, int index) {
                  final ForumThread thread = state.threads[index];
                  return ForumThreadCard(
                    thread: thread,
                    onTap: () => context.pushNamed(
                      ForumRoutes.threadName,
                      extra: thread,
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

/// Centered single-line message used for the empty and failure states.
class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTypography.subtitle,
        ),
      ),
    );
  }
}
