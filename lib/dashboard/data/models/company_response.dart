import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/company.dart';

part 'company_response.g.dart';

/// Inbound network contract describing the company payload returned by the
/// ELYSIUM `/api/v1/companies` resource.
///
/// A raw serialization boundary aligned with the IAM `*Response` convention: it
/// mirrors the snake_case wire schema exactly and carries no business behavior.
/// Deserialization is delegated to the generated `@JsonSerializable` schema;
/// projection into the pure domain layer is exposed through [toDomain]. Marked
/// inbound-only (`createToJson: false`) since the client never serializes this
/// type outward.
@JsonSerializable(createToJson: false)
class CompanyResponse {
  /// Creates a [CompanyResponse] from its explicit wire fields.
  const CompanyResponse({
    required this.companyId,
    required this.name,
    required this.ruc,
    required this.contactEmail,
    required this.contactPhone,
  });

  /// Server-driven unique identifier of the company.
  @JsonKey(name: 'company_id')
  final int companyId;

  /// Legal / commercial name of the company.
  @JsonKey(name: 'name')
  final String name;

  /// Peruvian tax identifier (RUC). Note the backend collapses the consecutive
  /// capitals of `RUC` into the lowercase key `ruc`.
  @JsonKey(name: 'ruc')
  final String ruc;

  /// Primary contact email address for the company.
  @JsonKey(name: 'contact_email')
  final String contactEmail;

  /// Primary contact phone number for the company.
  @JsonKey(name: 'contact_phone')
  final String contactPhone;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory CompanyResponse.fromJson(Map<String, dynamic> json) =>
      _$CompanyResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [Company] entity, wrapping
  /// the numeric identifier in the shared [Id] value object.
  Company toDomain() {
    return Company(
      id: Id(companyId.toString()),
      name: name,
      ruc: ruc,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
    );
  }
}
