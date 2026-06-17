/// Universal, framework-agnostic identifier value object reusable by every
/// bounded context.
///
/// Wrapping a raw [String] in a dedicated type prevents accidental mixing of
/// unrelated identifiers (passing a user id where a session id is expected) and
/// gives a single place to evolve identifier semantics later. It belongs to the
/// shared *domain* layer and therefore carries no annotations, serialization
/// tokens or infrastructure dependencies.
class Id {
  /// Creates an [Id] from its raw string [value].
  const Id(this.value);

  /// Creates an empty [Id], useful as a non-null placeholder.
  const Id.empty() : value = '';

  /// The underlying raw identifier.
  final String value;

  /// Whether this identifier carries no value.
  bool get isEmpty => value.isEmpty;

  /// Whether this identifier carries a value.
  bool get isNotEmpty => value.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Id && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
