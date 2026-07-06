import '../../../shared/domain/models/id.dart';

/// Immutable core domain entity describing a functional area (department) that
/// belongs to a [Company] and is tracked by the HR Analytics dashboard.
///
/// Pure by construction: it holds only intrinsic organizational attributes and
/// implements value equality by hand, carrying no serialization or
/// infrastructure concerns.
class AreaCompany {
  /// Creates an immutable [AreaCompany].
  const AreaCompany({
    required this.id,
    required this.name,
    required this.annualBudget,
  });

  /// Stable unique identifier assigned by the backend (`area_company_id`).
  final Id id;

  /// Human-readable name of the area (e.g. "Software Development").
  final String name;

  /// Yearly operating budget allocated to the area, expressed as a whole
  /// currency amount.
  final int annualBudget;

  /// Returns a copy of this [AreaCompany] overriding only the provided fields.
  AreaCompany copyWith({
    Id? id,
    String? name,
    int? annualBudget,
  }) {
    return AreaCompany(
      id: id ?? this.id,
      name: name ?? this.name,
      annualBudget: annualBudget ?? this.annualBudget,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AreaCompany &&
        other.id == id &&
        other.name == name &&
        other.annualBudget == annualBudget;
  }

  @override
  int get hashCode => Object.hash(id, name, annualBudget);

  @override
  String toString() =>
      'AreaCompany(id: $id, name: $name, annualBudget: $annualBudget)';
}
