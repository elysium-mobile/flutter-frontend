import '../../../shared/domain/models/id.dart';

/// Immutable core domain entity describing an employer company tracked by the
/// HR Analytics dashboard.
///
/// Completely pure: no annotations, serialization tokens or infrastructure
/// dependencies cross into it. Value equality is implemented by hand to keep the
/// entity framework-agnostic, mirroring the IAM domain conventions.
class Company {
  /// Creates an immutable [Company].
  const Company({
    required this.id,
    required this.name,
    required this.ruc,
    required this.contactEmail,
    required this.contactPhone,
  });

  /// Stable unique identifier assigned by the backend (`company_id`).
  final Id id;

  /// Legal / commercial name of the company.
  final String name;

  /// Peruvian tax identifier (RUC) uniquely identifying the company.
  final String ruc;

  /// Primary contact email address for the company.
  final String contactEmail;

  /// Primary contact phone number for the company.
  final String contactPhone;

  /// Returns a copy of this [Company] overriding only the provided fields.
  Company copyWith({
    Id? id,
    String? name,
    String? ruc,
    String? contactEmail,
    String? contactPhone,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      ruc: ruc ?? this.ruc,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Company &&
        other.id == id &&
        other.name == name &&
        other.ruc == ruc &&
        other.contactEmail == contactEmail &&
        other.contactPhone == contactPhone;
  }

  @override
  int get hashCode =>
      Object.hash(id, name, ruc, contactEmail, contactPhone);

  @override
  String toString() => 'Company(id: $id, name: $name, ruc: $ruc)';
}
