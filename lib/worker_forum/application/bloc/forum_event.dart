part of 'forum_bloc.dart';

/// Base type for every intent the forum screen dispatches to [ForumBloc].
sealed class ForumEvent extends Equatable {
  /// Const constructor for subclasses.
  const ForumEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// The forum screen was opened; load the company's threads.
final class ForumStarted extends ForumEvent {
  /// Creates a [ForumStarted].
  const ForumStarted();
}
