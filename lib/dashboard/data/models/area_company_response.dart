import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/area_company.dart';

part 'area_company_response.g.dart';

/// Inbound network contract describing the area payload returned by the ELYSIUM
/// `/api/v1/area-company` resource.
///
/// A raw serialization boundary mirroring the snake_case wire schema. Only the
/// intrinsic area attributes are mapped here; nested collections returned by the
/// backend are intentionally omitted from this dashboard projection.
/// Deserialization is delegated to the generated schema; projection into the
/// pure domain layer is exposed through [toDomain]. Marked inbound-only
/// (`createToJson: false`).
@JsonSerializable(createToJson: false)
class AreaCompanyResponse {
  /// Creates an [AreaCompanyResponse] from its explicit wire fields.
  const AreaCompanyResponse({
    required this.areaCompanyId,
    required this.name,
    required this.annualBudget,
  });

  /// Server-driven unique identifier of the area.
  @JsonKey(name: 'area_company_id')
  final int areaCompanyId;

  /// Human-readable name of the area.
  @JsonKey(name: 'name')
  final String name;

  /// Yearly operating budget allocated to the area.
  @JsonKey(name: 'annual_budget')
  final int annualBudget;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory AreaCompanyResponse.fromJson(Map<String, dynamic> json) =>
      _$AreaCompanyResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [AreaCompany] entity,
  /// wrapping the numeric identifier in the shared [Id] value object.
  AreaCompany toDomain() {
    return AreaCompany(
      id: Id(areaCompanyId.toString()),
      name: name,
      annualBudget: annualBudget,
    );
  }
}
