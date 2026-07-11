part of 'forum_bloc.dart';

/// Lifecycle status of the forum flow, decoupled from any UI representation.
enum ForumStatus {
  /// Nothing has been requested yet.
  initial,

  /// The company's threads are being fetched.
  loading,

  /// Threads are available.
  ready,

  /// A load failed; inspect [ForumState.errorMessage].
  failure,
}

/// Immutable state of the Worker Forum thread list managed by [ForumBloc].
final class ForumState extends Equatable {
  /// Creates a [ForumState].
  const ForumState({
    this.status = ForumStatus.initial,
    this.threads = const <ForumThread>[],
    this.errorMessage,
  });

  /// Current lifecycle status of the flow.
  final ForumStatus status;

  /// Company-scoped threads populating the list.
  final List<ForumThread> threads;

  /// Raw diagnostic error message when [status] is [ForumStatus.failure].
  final String? errorMessage;

  /// Returns a copy overriding the provided fields. [errorMessage] uses a
  /// sentinel so it can be explicitly cleared to `null`.
  ForumState copyWith({
    ForumStatus? status,
    List<ForumThread>? threads,
    Object? errorMessage = _sentinel,
  }) {
    return ForumState(
      status: status ?? this.status,
      threads: threads ?? this.threads,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, threads, errorMessage];
}

/// Private sentinel distinguishing "field omitted" from "field set to null".
const Object _sentinel = Object();
