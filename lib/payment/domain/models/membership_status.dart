/// Lifecycle classification of a subscription membership.
///
/// The backend serializes the raw status as an uppercase string (e.g.
/// `ACTIVE`); this pure enum normalizes it so the domain and routing layers can
/// reason about access without string comparisons.
enum MembershipStatus {
  /// The membership is active and grants full platform access.
  active,

  /// The membership exists but is no longer active (expired or cancelled).
  expired,

  /// The status could not be determined.
  unknown;

  /// Projects a raw backend `membership_status` string onto a [MembershipStatus].
  ///
  /// Any value other than the canonical `ACTIVE` token is treated as [expired],
  /// matching the "membership_status != ACTIVE" access rule.
  static MembershipStatus fromApi(String? raw) {
    if (raw == null || raw.isEmpty) return MembershipStatus.unknown;
    return raw.toUpperCase() == 'ACTIVE'
        ? MembershipStatus.active
        : MembershipStatus.expired;
  }

  /// Canonical backend token for this status.
  String get apiValue {
    switch (this) {
      case MembershipStatus.active:
        return 'ACTIVE';
      case MembershipStatus.expired:
        return 'EXPIRED';
      case MembershipStatus.unknown:
        return 'UNKNOWN';
    }
  }

  /// Whether this status grants access (only [active] does).
  bool get isActive => this == MembershipStatus.active;
}
