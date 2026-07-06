import 'package:drift/drift.dart' show Value;

import '../../../shared/data/local/app_database.dart';
import '../../../shared/domain/models/id.dart';
import '../../domain/models/membership.dart';
import '../../domain/models/membership_status.dart';
import '../../domain/models/payment_card.dart';

/// Structural mapping from a persisted [SavedCardRow] to the pure-domain
/// [PaymentCard] entity.
extension SavedCardRowMapper on SavedCardRow {
  /// Rehydrates a domain [PaymentCard] from this saved-card row.
  PaymentCard toDomain() {
    return PaymentCard(
      id: Id(id.toString()),
      cardHolder: cardHolder,
      last4: last4,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      brand: brand,
    );
  }
}

/// Structural mapping from a domain [PaymentCard] to a [SavedCardsCompanion].
///
/// The auto-incremented primary key is intentionally left absent so Drift
/// assigns it on insert.
extension PaymentCardCompanionMapper on PaymentCard {
  /// Converts this domain card into a [SavedCardsCompanion] payload.
  SavedCardsCompanion toCompanion() {
    return SavedCardsCompanion(
      cardHolder: Value(cardHolder),
      last4: Value(last4),
      expiryMonth: Value(expiryMonth),
      expiryYear: Value(expiryYear),
      brand: Value(brand),
    );
  }
}

/// Structural mapping from a persisted [CachedMembershipRow] to the pure-domain
/// [Membership] entity.
extension CachedMembershipRowMapper on CachedMembershipRow {
  /// Rehydrates a domain [Membership] from this cached row.
  Membership toDomain() {
    return Membership(
      id: Id(membershipId),
      status: MembershipStatus.fromApi(membershipStatus),
      start: membershipStart == null
          ? null
          : DateTime.tryParse(membershipStart!),
      over:
          membershipOver == null ? null : DateTime.tryParse(membershipOver!),
    );
  }
}

/// Structural mapping from a domain [Membership] to a
/// [CachedMembershipsCompanion] used to synchronize the local mirror.
extension MembershipCompanionMapper on Membership {
  /// Converts this domain membership into a [CachedMembershipsCompanion]
  /// payload, serializing the dates as ISO-8601 day strings.
  CachedMembershipsCompanion toCompanion() {
    return CachedMembershipsCompanion(
      membershipId: Value(id.value),
      membershipStart: Value(start?.toIso8601String()),
      membershipOver: Value(over?.toIso8601String()),
      membershipStatus: Value(status.apiValue),
    );
  }
}
