// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedSessionsTable extends CachedSessions
    with TableInfo<$CachedSessionsTable, CachedSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, accessToken, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accessTokenMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
    );
  }

  @override
  $CachedSessionsTable createAlias(String alias) {
    return $CachedSessionsTable(attachedDatabase, alias);
  }
}

class CachedSessionRow extends DataClass
    implements Insertable<CachedSessionRow> {
  /// Unique auto-incremented local identifier for the row mapping.
  ///
  /// Acts as the surrogate primary key; Drift derives the `PRIMARY KEY
  /// AUTOINCREMENT` constraint from [autoIncrement].
  final int id;

  /// The authoritative access token string payload for the session.
  ///
  /// Stored verbatim as an opaque bearer credential; never `null`.
  final String accessToken;

  /// Server-driven profile identifier associated with this login session.
  ///
  /// Correlates the cached credential with the owning user record; never
  /// `null`.
  final String userId;
  const CachedSessionRow({
    required this.id,
    required this.accessToken,
    required this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['access_token'] = Variable<String>(accessToken);
    map['user_id'] = Variable<String>(userId);
    return map;
  }

  CachedSessionsCompanion toCompanion(bool nullToAbsent) {
    return CachedSessionsCompanion(
      id: Value(id),
      accessToken: Value(accessToken),
      userId: Value(userId),
    );
  }

  factory CachedSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSessionRow(
      id: serializer.fromJson<int>(json['id']),
      accessToken: serializer.fromJson<String>(json['accessToken']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accessToken': serializer.toJson<String>(accessToken),
      'userId': serializer.toJson<String>(userId),
    };
  }

  CachedSessionRow copyWith({int? id, String? accessToken, String? userId}) =>
      CachedSessionRow(
        id: id ?? this.id,
        accessToken: accessToken ?? this.accessToken,
        userId: userId ?? this.userId,
      );
  CachedSessionRow copyWithCompanion(CachedSessionsCompanion data) {
    return CachedSessionRow(
      id: data.id.present ? data.id.value : this.id,
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSessionRow(')
          ..write('id: $id, ')
          ..write('accessToken: $accessToken, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accessToken, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSessionRow &&
          other.id == this.id &&
          other.accessToken == this.accessToken &&
          other.userId == this.userId);
}

class CachedSessionsCompanion extends UpdateCompanion<CachedSessionRow> {
  final Value<int> id;
  final Value<String> accessToken;
  final Value<String> userId;
  const CachedSessionsCompanion({
    this.id = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.userId = const Value.absent(),
  });
  CachedSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String accessToken,
    required String userId,
  }) : accessToken = Value(accessToken),
       userId = Value(userId);
  static Insertable<CachedSessionRow> custom({
    Expression<int>? id,
    Expression<String>? accessToken,
    Expression<String>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accessToken != null) 'access_token': accessToken,
      if (userId != null) 'user_id': userId,
    });
  }

  CachedSessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? accessToken,
    Value<String>? userId,
  }) {
    return CachedSessionsCompanion(
      id: id ?? this.id,
      accessToken: accessToken ?? this.accessToken,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSessionsCompanion(')
          ..write('id: $id, ')
          ..write('accessToken: $accessToken, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $CachedCompaniesTable extends CachedCompanies
    with TableInfo<$CachedCompaniesTable, CachedCompanyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCompaniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rucMeta = const VerificationMeta('ruc');
  @override
  late final GeneratedColumn<String> ruc = GeneratedColumn<String>(
    'ruc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactEmailMeta = const VerificationMeta(
    'contactEmail',
  );
  @override
  late final GeneratedColumn<String> contactEmail = GeneratedColumn<String>(
    'contact_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactPhoneMeta = const VerificationMeta(
    'contactPhone',
  );
  @override
  late final GeneratedColumn<String> contactPhone = GeneratedColumn<String>(
    'contact_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    companyId,
    name,
    ruc,
    contactEmail,
    contactPhone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_companies';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCompanyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ruc')) {
      context.handle(
        _rucMeta,
        ruc.isAcceptableOrUnknown(data['ruc']!, _rucMeta),
      );
    } else if (isInserting) {
      context.missing(_rucMeta);
    }
    if (data.containsKey('contact_email')) {
      context.handle(
        _contactEmailMeta,
        contactEmail.isAcceptableOrUnknown(
          data['contact_email']!,
          _contactEmailMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contactEmailMeta);
    }
    if (data.containsKey('contact_phone')) {
      context.handle(
        _contactPhoneMeta,
        contactPhone.isAcceptableOrUnknown(
          data['contact_phone']!,
          _contactPhoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contactPhoneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {companyId};
  @override
  CachedCompanyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCompanyRow(
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ruc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruc'],
      )!,
      contactEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_email'],
      )!,
      contactPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_phone'],
      )!,
    );
  }

  @override
  $CachedCompaniesTable createAlias(String alias) {
    return $CachedCompaniesTable(attachedDatabase, alias);
  }
}

class CachedCompanyRow extends DataClass
    implements Insertable<CachedCompanyRow> {
  /// Server-driven company identifier; acts as the natural primary key.
  final String companyId;

  /// Legal / commercial name of the company.
  final String name;

  /// Peruvian tax identifier (RUC) of the company.
  final String ruc;

  /// Primary contact email address for the company.
  final String contactEmail;

  /// Primary contact phone number for the company.
  final String contactPhone;
  const CachedCompanyRow({
    required this.companyId,
    required this.name,
    required this.ruc,
    required this.contactEmail,
    required this.contactPhone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['company_id'] = Variable<String>(companyId);
    map['name'] = Variable<String>(name);
    map['ruc'] = Variable<String>(ruc);
    map['contact_email'] = Variable<String>(contactEmail);
    map['contact_phone'] = Variable<String>(contactPhone);
    return map;
  }

  CachedCompaniesCompanion toCompanion(bool nullToAbsent) {
    return CachedCompaniesCompanion(
      companyId: Value(companyId),
      name: Value(name),
      ruc: Value(ruc),
      contactEmail: Value(contactEmail),
      contactPhone: Value(contactPhone),
    );
  }

  factory CachedCompanyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCompanyRow(
      companyId: serializer.fromJson<String>(json['companyId']),
      name: serializer.fromJson<String>(json['name']),
      ruc: serializer.fromJson<String>(json['ruc']),
      contactEmail: serializer.fromJson<String>(json['contactEmail']),
      contactPhone: serializer.fromJson<String>(json['contactPhone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'companyId': serializer.toJson<String>(companyId),
      'name': serializer.toJson<String>(name),
      'ruc': serializer.toJson<String>(ruc),
      'contactEmail': serializer.toJson<String>(contactEmail),
      'contactPhone': serializer.toJson<String>(contactPhone),
    };
  }

  CachedCompanyRow copyWith({
    String? companyId,
    String? name,
    String? ruc,
    String? contactEmail,
    String? contactPhone,
  }) => CachedCompanyRow(
    companyId: companyId ?? this.companyId,
    name: name ?? this.name,
    ruc: ruc ?? this.ruc,
    contactEmail: contactEmail ?? this.contactEmail,
    contactPhone: contactPhone ?? this.contactPhone,
  );
  CachedCompanyRow copyWithCompanion(CachedCompaniesCompanion data) {
    return CachedCompanyRow(
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      name: data.name.present ? data.name.value : this.name,
      ruc: data.ruc.present ? data.ruc.value : this.ruc,
      contactEmail: data.contactEmail.present
          ? data.contactEmail.value
          : this.contactEmail,
      contactPhone: data.contactPhone.present
          ? data.contactPhone.value
          : this.contactPhone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCompanyRow(')
          ..write('companyId: $companyId, ')
          ..write('name: $name, ')
          ..write('ruc: $ruc, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('contactPhone: $contactPhone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(companyId, name, ruc, contactEmail, contactPhone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCompanyRow &&
          other.companyId == this.companyId &&
          other.name == this.name &&
          other.ruc == this.ruc &&
          other.contactEmail == this.contactEmail &&
          other.contactPhone == this.contactPhone);
}

class CachedCompaniesCompanion extends UpdateCompanion<CachedCompanyRow> {
  final Value<String> companyId;
  final Value<String> name;
  final Value<String> ruc;
  final Value<String> contactEmail;
  final Value<String> contactPhone;
  final Value<int> rowid;
  const CachedCompaniesCompanion({
    this.companyId = const Value.absent(),
    this.name = const Value.absent(),
    this.ruc = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedCompaniesCompanion.insert({
    required String companyId,
    required String name,
    required String ruc,
    required String contactEmail,
    required String contactPhone,
    this.rowid = const Value.absent(),
  }) : companyId = Value(companyId),
       name = Value(name),
       ruc = Value(ruc),
       contactEmail = Value(contactEmail),
       contactPhone = Value(contactPhone);
  static Insertable<CachedCompanyRow> custom({
    Expression<String>? companyId,
    Expression<String>? name,
    Expression<String>? ruc,
    Expression<String>? contactEmail,
    Expression<String>? contactPhone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (companyId != null) 'company_id': companyId,
      if (name != null) 'name': name,
      if (ruc != null) 'ruc': ruc,
      if (contactEmail != null) 'contact_email': contactEmail,
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedCompaniesCompanion copyWith({
    Value<String>? companyId,
    Value<String>? name,
    Value<String>? ruc,
    Value<String>? contactEmail,
    Value<String>? contactPhone,
    Value<int>? rowid,
  }) {
    return CachedCompaniesCompanion(
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      ruc: ruc ?? this.ruc,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ruc.present) {
      map['ruc'] = Variable<String>(ruc.value);
    }
    if (contactEmail.present) {
      map['contact_email'] = Variable<String>(contactEmail.value);
    }
    if (contactPhone.present) {
      map['contact_phone'] = Variable<String>(contactPhone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCompaniesCompanion(')
          ..write('companyId: $companyId, ')
          ..write('name: $name, ')
          ..write('ruc: $ruc, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedAreaCompaniesTable extends CachedAreaCompanies
    with TableInfo<$CachedAreaCompaniesTable, CachedAreaCompanyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAreaCompaniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _areaCompanyIdMeta = const VerificationMeta(
    'areaCompanyId',
  );
  @override
  late final GeneratedColumn<String> areaCompanyId = GeneratedColumn<String>(
    'area_company_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _annualBudgetMeta = const VerificationMeta(
    'annualBudget',
  );
  @override
  late final GeneratedColumn<int> annualBudget = GeneratedColumn<int>(
    'annual_budget',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [areaCompanyId, name, annualBudget];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_area_companies';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedAreaCompanyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('area_company_id')) {
      context.handle(
        _areaCompanyIdMeta,
        areaCompanyId.isAcceptableOrUnknown(
          data['area_company_id']!,
          _areaCompanyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_areaCompanyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('annual_budget')) {
      context.handle(
        _annualBudgetMeta,
        annualBudget.isAcceptableOrUnknown(
          data['annual_budget']!,
          _annualBudgetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_annualBudgetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {areaCompanyId};
  @override
  CachedAreaCompanyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAreaCompanyRow(
      areaCompanyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area_company_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      annualBudget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}annual_budget'],
      )!,
    );
  }

  @override
  $CachedAreaCompaniesTable createAlias(String alias) {
    return $CachedAreaCompaniesTable(attachedDatabase, alias);
  }
}

class CachedAreaCompanyRow extends DataClass
    implements Insertable<CachedAreaCompanyRow> {
  /// Server-driven area identifier; acts as the natural primary key.
  final String areaCompanyId;

  /// Human-readable name of the area.
  final String name;

  /// Yearly operating budget allocated to the area.
  final int annualBudget;
  const CachedAreaCompanyRow({
    required this.areaCompanyId,
    required this.name,
    required this.annualBudget,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['area_company_id'] = Variable<String>(areaCompanyId);
    map['name'] = Variable<String>(name);
    map['annual_budget'] = Variable<int>(annualBudget);
    return map;
  }

  CachedAreaCompaniesCompanion toCompanion(bool nullToAbsent) {
    return CachedAreaCompaniesCompanion(
      areaCompanyId: Value(areaCompanyId),
      name: Value(name),
      annualBudget: Value(annualBudget),
    );
  }

  factory CachedAreaCompanyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAreaCompanyRow(
      areaCompanyId: serializer.fromJson<String>(json['areaCompanyId']),
      name: serializer.fromJson<String>(json['name']),
      annualBudget: serializer.fromJson<int>(json['annualBudget']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'areaCompanyId': serializer.toJson<String>(areaCompanyId),
      'name': serializer.toJson<String>(name),
      'annualBudget': serializer.toJson<int>(annualBudget),
    };
  }

  CachedAreaCompanyRow copyWith({
    String? areaCompanyId,
    String? name,
    int? annualBudget,
  }) => CachedAreaCompanyRow(
    areaCompanyId: areaCompanyId ?? this.areaCompanyId,
    name: name ?? this.name,
    annualBudget: annualBudget ?? this.annualBudget,
  );
  CachedAreaCompanyRow copyWithCompanion(CachedAreaCompaniesCompanion data) {
    return CachedAreaCompanyRow(
      areaCompanyId: data.areaCompanyId.present
          ? data.areaCompanyId.value
          : this.areaCompanyId,
      name: data.name.present ? data.name.value : this.name,
      annualBudget: data.annualBudget.present
          ? data.annualBudget.value
          : this.annualBudget,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAreaCompanyRow(')
          ..write('areaCompanyId: $areaCompanyId, ')
          ..write('name: $name, ')
          ..write('annualBudget: $annualBudget')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(areaCompanyId, name, annualBudget);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAreaCompanyRow &&
          other.areaCompanyId == this.areaCompanyId &&
          other.name == this.name &&
          other.annualBudget == this.annualBudget);
}

class CachedAreaCompaniesCompanion
    extends UpdateCompanion<CachedAreaCompanyRow> {
  final Value<String> areaCompanyId;
  final Value<String> name;
  final Value<int> annualBudget;
  final Value<int> rowid;
  const CachedAreaCompaniesCompanion({
    this.areaCompanyId = const Value.absent(),
    this.name = const Value.absent(),
    this.annualBudget = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAreaCompaniesCompanion.insert({
    required String areaCompanyId,
    required String name,
    required int annualBudget,
    this.rowid = const Value.absent(),
  }) : areaCompanyId = Value(areaCompanyId),
       name = Value(name),
       annualBudget = Value(annualBudget);
  static Insertable<CachedAreaCompanyRow> custom({
    Expression<String>? areaCompanyId,
    Expression<String>? name,
    Expression<int>? annualBudget,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (areaCompanyId != null) 'area_company_id': areaCompanyId,
      if (name != null) 'name': name,
      if (annualBudget != null) 'annual_budget': annualBudget,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAreaCompaniesCompanion copyWith({
    Value<String>? areaCompanyId,
    Value<String>? name,
    Value<int>? annualBudget,
    Value<int>? rowid,
  }) {
    return CachedAreaCompaniesCompanion(
      areaCompanyId: areaCompanyId ?? this.areaCompanyId,
      name: name ?? this.name,
      annualBudget: annualBudget ?? this.annualBudget,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (areaCompanyId.present) {
      map['area_company_id'] = Variable<String>(areaCompanyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (annualBudget.present) {
      map['annual_budget'] = Variable<int>(annualBudget.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedAreaCompaniesCompanion(')
          ..write('areaCompanyId: $areaCompanyId, ')
          ..write('name: $name, ')
          ..write('annualBudget: $annualBudget, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedWorkTeamsTable extends CachedWorkTeams
    with TableInfo<$CachedWorkTeamsTable, CachedWorkTeamRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedWorkTeamsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workTeamIdMeta = const VerificationMeta(
    'workTeamId',
  );
  @override
  late final GeneratedColumn<String> workTeamId = GeneratedColumn<String>(
    'work_team_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamNameMeta = const VerificationMeta(
    'teamName',
  );
  @override
  late final GeneratedColumn<String> teamName = GeneratedColumn<String>(
    'team_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leaderOfTeamMeta = const VerificationMeta(
    'leaderOfTeam',
  );
  @override
  late final GeneratedColumn<String> leaderOfTeam = GeneratedColumn<String>(
    'leader_of_team',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitOfWorkIdMeta = const VerificationMeta(
    'unitOfWorkId',
  );
  @override
  late final GeneratedColumn<String> unitOfWorkId = GeneratedColumn<String>(
    'unit_of_work_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    workTeamId,
    teamName,
    leaderOfTeam,
    unitOfWorkId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_work_teams';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedWorkTeamRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('work_team_id')) {
      context.handle(
        _workTeamIdMeta,
        workTeamId.isAcceptableOrUnknown(
          data['work_team_id']!,
          _workTeamIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workTeamIdMeta);
    }
    if (data.containsKey('team_name')) {
      context.handle(
        _teamNameMeta,
        teamName.isAcceptableOrUnknown(data['team_name']!, _teamNameMeta),
      );
    } else if (isInserting) {
      context.missing(_teamNameMeta);
    }
    if (data.containsKey('leader_of_team')) {
      context.handle(
        _leaderOfTeamMeta,
        leaderOfTeam.isAcceptableOrUnknown(
          data['leader_of_team']!,
          _leaderOfTeamMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_leaderOfTeamMeta);
    }
    if (data.containsKey('unit_of_work_id')) {
      context.handle(
        _unitOfWorkIdMeta,
        unitOfWorkId.isAcceptableOrUnknown(
          data['unit_of_work_id']!,
          _unitOfWorkIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitOfWorkIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workTeamId};
  @override
  CachedWorkTeamRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedWorkTeamRow(
      workTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_team_id'],
      )!,
      teamName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_name'],
      )!,
      leaderOfTeam: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leader_of_team'],
      )!,
      unitOfWorkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_of_work_id'],
      )!,
    );
  }

  @override
  $CachedWorkTeamsTable createAlias(String alias) {
    return $CachedWorkTeamsTable(attachedDatabase, alias);
  }
}

class CachedWorkTeamRow extends DataClass
    implements Insertable<CachedWorkTeamRow> {
  /// Server-driven work-team identifier; acts as the natural primary key.
  final String workTeamId;

  /// Display name of the team.
  final String teamName;

  /// Full name of the person leading the team.
  final String leaderOfTeam;

  /// Identifier of the owning unit of work.
  final String unitOfWorkId;
  const CachedWorkTeamRow({
    required this.workTeamId,
    required this.teamName,
    required this.leaderOfTeam,
    required this.unitOfWorkId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['work_team_id'] = Variable<String>(workTeamId);
    map['team_name'] = Variable<String>(teamName);
    map['leader_of_team'] = Variable<String>(leaderOfTeam);
    map['unit_of_work_id'] = Variable<String>(unitOfWorkId);
    return map;
  }

  CachedWorkTeamsCompanion toCompanion(bool nullToAbsent) {
    return CachedWorkTeamsCompanion(
      workTeamId: Value(workTeamId),
      teamName: Value(teamName),
      leaderOfTeam: Value(leaderOfTeam),
      unitOfWorkId: Value(unitOfWorkId),
    );
  }

  factory CachedWorkTeamRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedWorkTeamRow(
      workTeamId: serializer.fromJson<String>(json['workTeamId']),
      teamName: serializer.fromJson<String>(json['teamName']),
      leaderOfTeam: serializer.fromJson<String>(json['leaderOfTeam']),
      unitOfWorkId: serializer.fromJson<String>(json['unitOfWorkId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workTeamId': serializer.toJson<String>(workTeamId),
      'teamName': serializer.toJson<String>(teamName),
      'leaderOfTeam': serializer.toJson<String>(leaderOfTeam),
      'unitOfWorkId': serializer.toJson<String>(unitOfWorkId),
    };
  }

  CachedWorkTeamRow copyWith({
    String? workTeamId,
    String? teamName,
    String? leaderOfTeam,
    String? unitOfWorkId,
  }) => CachedWorkTeamRow(
    workTeamId: workTeamId ?? this.workTeamId,
    teamName: teamName ?? this.teamName,
    leaderOfTeam: leaderOfTeam ?? this.leaderOfTeam,
    unitOfWorkId: unitOfWorkId ?? this.unitOfWorkId,
  );
  CachedWorkTeamRow copyWithCompanion(CachedWorkTeamsCompanion data) {
    return CachedWorkTeamRow(
      workTeamId: data.workTeamId.present
          ? data.workTeamId.value
          : this.workTeamId,
      teamName: data.teamName.present ? data.teamName.value : this.teamName,
      leaderOfTeam: data.leaderOfTeam.present
          ? data.leaderOfTeam.value
          : this.leaderOfTeam,
      unitOfWorkId: data.unitOfWorkId.present
          ? data.unitOfWorkId.value
          : this.unitOfWorkId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedWorkTeamRow(')
          ..write('workTeamId: $workTeamId, ')
          ..write('teamName: $teamName, ')
          ..write('leaderOfTeam: $leaderOfTeam, ')
          ..write('unitOfWorkId: $unitOfWorkId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(workTeamId, teamName, leaderOfTeam, unitOfWorkId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedWorkTeamRow &&
          other.workTeamId == this.workTeamId &&
          other.teamName == this.teamName &&
          other.leaderOfTeam == this.leaderOfTeam &&
          other.unitOfWorkId == this.unitOfWorkId);
}

class CachedWorkTeamsCompanion extends UpdateCompanion<CachedWorkTeamRow> {
  final Value<String> workTeamId;
  final Value<String> teamName;
  final Value<String> leaderOfTeam;
  final Value<String> unitOfWorkId;
  final Value<int> rowid;
  const CachedWorkTeamsCompanion({
    this.workTeamId = const Value.absent(),
    this.teamName = const Value.absent(),
    this.leaderOfTeam = const Value.absent(),
    this.unitOfWorkId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedWorkTeamsCompanion.insert({
    required String workTeamId,
    required String teamName,
    required String leaderOfTeam,
    required String unitOfWorkId,
    this.rowid = const Value.absent(),
  }) : workTeamId = Value(workTeamId),
       teamName = Value(teamName),
       leaderOfTeam = Value(leaderOfTeam),
       unitOfWorkId = Value(unitOfWorkId);
  static Insertable<CachedWorkTeamRow> custom({
    Expression<String>? workTeamId,
    Expression<String>? teamName,
    Expression<String>? leaderOfTeam,
    Expression<String>? unitOfWorkId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workTeamId != null) 'work_team_id': workTeamId,
      if (teamName != null) 'team_name': teamName,
      if (leaderOfTeam != null) 'leader_of_team': leaderOfTeam,
      if (unitOfWorkId != null) 'unit_of_work_id': unitOfWorkId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedWorkTeamsCompanion copyWith({
    Value<String>? workTeamId,
    Value<String>? teamName,
    Value<String>? leaderOfTeam,
    Value<String>? unitOfWorkId,
    Value<int>? rowid,
  }) {
    return CachedWorkTeamsCompanion(
      workTeamId: workTeamId ?? this.workTeamId,
      teamName: teamName ?? this.teamName,
      leaderOfTeam: leaderOfTeam ?? this.leaderOfTeam,
      unitOfWorkId: unitOfWorkId ?? this.unitOfWorkId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workTeamId.present) {
      map['work_team_id'] = Variable<String>(workTeamId.value);
    }
    if (teamName.present) {
      map['team_name'] = Variable<String>(teamName.value);
    }
    if (leaderOfTeam.present) {
      map['leader_of_team'] = Variable<String>(leaderOfTeam.value);
    }
    if (unitOfWorkId.present) {
      map['unit_of_work_id'] = Variable<String>(unitOfWorkId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedWorkTeamsCompanion(')
          ..write('workTeamId: $workTeamId, ')
          ..write('teamName: $teamName, ')
          ..write('leaderOfTeam: $leaderOfTeam, ')
          ..write('unitOfWorkId: $unitOfWorkId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedCardsTable extends SavedCards
    with TableInfo<$SavedCardsTable, SavedCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardHolderMeta = const VerificationMeta(
    'cardHolder',
  );
  @override
  late final GeneratedColumn<String> cardHolder = GeneratedColumn<String>(
    'card_holder',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 4,
      maxTextLength: 4,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiryMonthMeta = const VerificationMeta(
    'expiryMonth',
  );
  @override
  late final GeneratedColumn<String> expiryMonth = GeneratedColumn<String>(
    'expiry_month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiryYearMeta = const VerificationMeta(
    'expiryYear',
  );
  @override
  late final GeneratedColumn<String> expiryYear = GeneratedColumn<String>(
    'expiry_year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardHolder,
    last4,
    expiryMonth,
    expiryYear,
    brand,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedCardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_holder')) {
      context.handle(
        _cardHolderMeta,
        cardHolder.isAcceptableOrUnknown(data['card_holder']!, _cardHolderMeta),
      );
    } else if (isInserting) {
      context.missing(_cardHolderMeta);
    }
    if (data.containsKey('last4')) {
      context.handle(
        _last4Meta,
        last4.isAcceptableOrUnknown(data['last4']!, _last4Meta),
      );
    } else if (isInserting) {
      context.missing(_last4Meta);
    }
    if (data.containsKey('expiry_month')) {
      context.handle(
        _expiryMonthMeta,
        expiryMonth.isAcceptableOrUnknown(
          data['expiry_month']!,
          _expiryMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expiryMonthMeta);
    }
    if (data.containsKey('expiry_year')) {
      context.handle(
        _expiryYearMeta,
        expiryYear.isAcceptableOrUnknown(data['expiry_year']!, _expiryYearMeta),
      );
    } else if (isInserting) {
      context.missing(_expiryYearMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedCardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardHolder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_holder'],
      )!,
      last4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last4'],
      )!,
      expiryMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expiry_month'],
      )!,
      expiryYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expiry_year'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
    );
  }

  @override
  $SavedCardsTable createAlias(String alias) {
    return $SavedCardsTable(attachedDatabase, alias);
  }
}

class SavedCardRow extends DataClass implements Insertable<SavedCardRow> {
  /// Unique auto-incremented local identifier for the saved card.
  final int id;

  /// Name embossed on the card.
  final String cardHolder;

  /// Last four digits of the primary account number.
  final String last4;

  /// Two-digit expiry month.
  final String expiryMonth;

  /// Four-digit expiry year.
  final String expiryYear;

  /// Detected card brand (e.g. "VISA").
  final String brand;
  const SavedCardRow({
    required this.id,
    required this.cardHolder,
    required this.last4,
    required this.expiryMonth,
    required this.expiryYear,
    required this.brand,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_holder'] = Variable<String>(cardHolder);
    map['last4'] = Variable<String>(last4);
    map['expiry_month'] = Variable<String>(expiryMonth);
    map['expiry_year'] = Variable<String>(expiryYear);
    map['brand'] = Variable<String>(brand);
    return map;
  }

  SavedCardsCompanion toCompanion(bool nullToAbsent) {
    return SavedCardsCompanion(
      id: Value(id),
      cardHolder: Value(cardHolder),
      last4: Value(last4),
      expiryMonth: Value(expiryMonth),
      expiryYear: Value(expiryYear),
      brand: Value(brand),
    );
  }

  factory SavedCardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedCardRow(
      id: serializer.fromJson<int>(json['id']),
      cardHolder: serializer.fromJson<String>(json['cardHolder']),
      last4: serializer.fromJson<String>(json['last4']),
      expiryMonth: serializer.fromJson<String>(json['expiryMonth']),
      expiryYear: serializer.fromJson<String>(json['expiryYear']),
      brand: serializer.fromJson<String>(json['brand']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardHolder': serializer.toJson<String>(cardHolder),
      'last4': serializer.toJson<String>(last4),
      'expiryMonth': serializer.toJson<String>(expiryMonth),
      'expiryYear': serializer.toJson<String>(expiryYear),
      'brand': serializer.toJson<String>(brand),
    };
  }

  SavedCardRow copyWith({
    int? id,
    String? cardHolder,
    String? last4,
    String? expiryMonth,
    String? expiryYear,
    String? brand,
  }) => SavedCardRow(
    id: id ?? this.id,
    cardHolder: cardHolder ?? this.cardHolder,
    last4: last4 ?? this.last4,
    expiryMonth: expiryMonth ?? this.expiryMonth,
    expiryYear: expiryYear ?? this.expiryYear,
    brand: brand ?? this.brand,
  );
  SavedCardRow copyWithCompanion(SavedCardsCompanion data) {
    return SavedCardRow(
      id: data.id.present ? data.id.value : this.id,
      cardHolder: data.cardHolder.present
          ? data.cardHolder.value
          : this.cardHolder,
      last4: data.last4.present ? data.last4.value : this.last4,
      expiryMonth: data.expiryMonth.present
          ? data.expiryMonth.value
          : this.expiryMonth,
      expiryYear: data.expiryYear.present
          ? data.expiryYear.value
          : this.expiryYear,
      brand: data.brand.present ? data.brand.value : this.brand,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedCardRow(')
          ..write('id: $id, ')
          ..write('cardHolder: $cardHolder, ')
          ..write('last4: $last4, ')
          ..write('expiryMonth: $expiryMonth, ')
          ..write('expiryYear: $expiryYear, ')
          ..write('brand: $brand')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cardHolder, last4, expiryMonth, expiryYear, brand);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedCardRow &&
          other.id == this.id &&
          other.cardHolder == this.cardHolder &&
          other.last4 == this.last4 &&
          other.expiryMonth == this.expiryMonth &&
          other.expiryYear == this.expiryYear &&
          other.brand == this.brand);
}

class SavedCardsCompanion extends UpdateCompanion<SavedCardRow> {
  final Value<int> id;
  final Value<String> cardHolder;
  final Value<String> last4;
  final Value<String> expiryMonth;
  final Value<String> expiryYear;
  final Value<String> brand;
  const SavedCardsCompanion({
    this.id = const Value.absent(),
    this.cardHolder = const Value.absent(),
    this.last4 = const Value.absent(),
    this.expiryMonth = const Value.absent(),
    this.expiryYear = const Value.absent(),
    this.brand = const Value.absent(),
  });
  SavedCardsCompanion.insert({
    this.id = const Value.absent(),
    required String cardHolder,
    required String last4,
    required String expiryMonth,
    required String expiryYear,
    required String brand,
  }) : cardHolder = Value(cardHolder),
       last4 = Value(last4),
       expiryMonth = Value(expiryMonth),
       expiryYear = Value(expiryYear),
       brand = Value(brand);
  static Insertable<SavedCardRow> custom({
    Expression<int>? id,
    Expression<String>? cardHolder,
    Expression<String>? last4,
    Expression<String>? expiryMonth,
    Expression<String>? expiryYear,
    Expression<String>? brand,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardHolder != null) 'card_holder': cardHolder,
      if (last4 != null) 'last4': last4,
      if (expiryMonth != null) 'expiry_month': expiryMonth,
      if (expiryYear != null) 'expiry_year': expiryYear,
      if (brand != null) 'brand': brand,
    });
  }

  SavedCardsCompanion copyWith({
    Value<int>? id,
    Value<String>? cardHolder,
    Value<String>? last4,
    Value<String>? expiryMonth,
    Value<String>? expiryYear,
    Value<String>? brand,
  }) {
    return SavedCardsCompanion(
      id: id ?? this.id,
      cardHolder: cardHolder ?? this.cardHolder,
      last4: last4 ?? this.last4,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      brand: brand ?? this.brand,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardHolder.present) {
      map['card_holder'] = Variable<String>(cardHolder.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (expiryMonth.present) {
      map['expiry_month'] = Variable<String>(expiryMonth.value);
    }
    if (expiryYear.present) {
      map['expiry_year'] = Variable<String>(expiryYear.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedCardsCompanion(')
          ..write('id: $id, ')
          ..write('cardHolder: $cardHolder, ')
          ..write('last4: $last4, ')
          ..write('expiryMonth: $expiryMonth, ')
          ..write('expiryYear: $expiryYear, ')
          ..write('brand: $brand')
          ..write(')'))
        .toString();
  }
}

class $CachedMembershipsTable extends CachedMemberships
    with TableInfo<$CachedMembershipsTable, CachedMembershipRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedMembershipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _membershipIdMeta = const VerificationMeta(
    'membershipId',
  );
  @override
  late final GeneratedColumn<String> membershipId = GeneratedColumn<String>(
    'membership_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _membershipStartMeta = const VerificationMeta(
    'membershipStart',
  );
  @override
  late final GeneratedColumn<String> membershipStart = GeneratedColumn<String>(
    'membership_start',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _membershipOverMeta = const VerificationMeta(
    'membershipOver',
  );
  @override
  late final GeneratedColumn<String> membershipOver = GeneratedColumn<String>(
    'membership_over',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _membershipStatusMeta = const VerificationMeta(
    'membershipStatus',
  );
  @override
  late final GeneratedColumn<String> membershipStatus = GeneratedColumn<String>(
    'membership_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    membershipId,
    membershipStart,
    membershipOver,
    membershipStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_memberships';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedMembershipRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('membership_id')) {
      context.handle(
        _membershipIdMeta,
        membershipId.isAcceptableOrUnknown(
          data['membership_id']!,
          _membershipIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_membershipIdMeta);
    }
    if (data.containsKey('membership_start')) {
      context.handle(
        _membershipStartMeta,
        membershipStart.isAcceptableOrUnknown(
          data['membership_start']!,
          _membershipStartMeta,
        ),
      );
    }
    if (data.containsKey('membership_over')) {
      context.handle(
        _membershipOverMeta,
        membershipOver.isAcceptableOrUnknown(
          data['membership_over']!,
          _membershipOverMeta,
        ),
      );
    }
    if (data.containsKey('membership_status')) {
      context.handle(
        _membershipStatusMeta,
        membershipStatus.isAcceptableOrUnknown(
          data['membership_status']!,
          _membershipStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_membershipStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedMembershipRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedMembershipRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      membershipId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}membership_id'],
      )!,
      membershipStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}membership_start'],
      ),
      membershipOver: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}membership_over'],
      ),
      membershipStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}membership_status'],
      )!,
    );
  }

  @override
  $CachedMembershipsTable createAlias(String alias) {
    return $CachedMembershipsTable(attachedDatabase, alias);
  }
}

class CachedMembershipRow extends DataClass
    implements Insertable<CachedMembershipRow> {
  /// Unique auto-incremented local identifier for the row.
  final int id;

  /// Server-driven membership identifier.
  final String membershipId;

  /// Inclusive start date (ISO-8601 day string), or `null` when unknown.
  final String? membershipStart;

  /// Exclusive end date (ISO-8601 day string), or `null` when unknown.
  final String? membershipOver;

  /// Raw lifecycle status token (e.g. `ACTIVE`).
  final String membershipStatus;
  const CachedMembershipRow({
    required this.id,
    required this.membershipId,
    this.membershipStart,
    this.membershipOver,
    required this.membershipStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['membership_id'] = Variable<String>(membershipId);
    if (!nullToAbsent || membershipStart != null) {
      map['membership_start'] = Variable<String>(membershipStart);
    }
    if (!nullToAbsent || membershipOver != null) {
      map['membership_over'] = Variable<String>(membershipOver);
    }
    map['membership_status'] = Variable<String>(membershipStatus);
    return map;
  }

  CachedMembershipsCompanion toCompanion(bool nullToAbsent) {
    return CachedMembershipsCompanion(
      id: Value(id),
      membershipId: Value(membershipId),
      membershipStart: membershipStart == null && nullToAbsent
          ? const Value.absent()
          : Value(membershipStart),
      membershipOver: membershipOver == null && nullToAbsent
          ? const Value.absent()
          : Value(membershipOver),
      membershipStatus: Value(membershipStatus),
    );
  }

  factory CachedMembershipRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedMembershipRow(
      id: serializer.fromJson<int>(json['id']),
      membershipId: serializer.fromJson<String>(json['membershipId']),
      membershipStart: serializer.fromJson<String?>(json['membershipStart']),
      membershipOver: serializer.fromJson<String?>(json['membershipOver']),
      membershipStatus: serializer.fromJson<String>(json['membershipStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'membershipId': serializer.toJson<String>(membershipId),
      'membershipStart': serializer.toJson<String?>(membershipStart),
      'membershipOver': serializer.toJson<String?>(membershipOver),
      'membershipStatus': serializer.toJson<String>(membershipStatus),
    };
  }

  CachedMembershipRow copyWith({
    int? id,
    String? membershipId,
    Value<String?> membershipStart = const Value.absent(),
    Value<String?> membershipOver = const Value.absent(),
    String? membershipStatus,
  }) => CachedMembershipRow(
    id: id ?? this.id,
    membershipId: membershipId ?? this.membershipId,
    membershipStart: membershipStart.present
        ? membershipStart.value
        : this.membershipStart,
    membershipOver: membershipOver.present
        ? membershipOver.value
        : this.membershipOver,
    membershipStatus: membershipStatus ?? this.membershipStatus,
  );
  CachedMembershipRow copyWithCompanion(CachedMembershipsCompanion data) {
    return CachedMembershipRow(
      id: data.id.present ? data.id.value : this.id,
      membershipId: data.membershipId.present
          ? data.membershipId.value
          : this.membershipId,
      membershipStart: data.membershipStart.present
          ? data.membershipStart.value
          : this.membershipStart,
      membershipOver: data.membershipOver.present
          ? data.membershipOver.value
          : this.membershipOver,
      membershipStatus: data.membershipStatus.present
          ? data.membershipStatus.value
          : this.membershipStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedMembershipRow(')
          ..write('id: $id, ')
          ..write('membershipId: $membershipId, ')
          ..write('membershipStart: $membershipStart, ')
          ..write('membershipOver: $membershipOver, ')
          ..write('membershipStatus: $membershipStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    membershipId,
    membershipStart,
    membershipOver,
    membershipStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedMembershipRow &&
          other.id == this.id &&
          other.membershipId == this.membershipId &&
          other.membershipStart == this.membershipStart &&
          other.membershipOver == this.membershipOver &&
          other.membershipStatus == this.membershipStatus);
}

class CachedMembershipsCompanion extends UpdateCompanion<CachedMembershipRow> {
  final Value<int> id;
  final Value<String> membershipId;
  final Value<String?> membershipStart;
  final Value<String?> membershipOver;
  final Value<String> membershipStatus;
  const CachedMembershipsCompanion({
    this.id = const Value.absent(),
    this.membershipId = const Value.absent(),
    this.membershipStart = const Value.absent(),
    this.membershipOver = const Value.absent(),
    this.membershipStatus = const Value.absent(),
  });
  CachedMembershipsCompanion.insert({
    this.id = const Value.absent(),
    required String membershipId,
    this.membershipStart = const Value.absent(),
    this.membershipOver = const Value.absent(),
    required String membershipStatus,
  }) : membershipId = Value(membershipId),
       membershipStatus = Value(membershipStatus);
  static Insertable<CachedMembershipRow> custom({
    Expression<int>? id,
    Expression<String>? membershipId,
    Expression<String>? membershipStart,
    Expression<String>? membershipOver,
    Expression<String>? membershipStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (membershipId != null) 'membership_id': membershipId,
      if (membershipStart != null) 'membership_start': membershipStart,
      if (membershipOver != null) 'membership_over': membershipOver,
      if (membershipStatus != null) 'membership_status': membershipStatus,
    });
  }

  CachedMembershipsCompanion copyWith({
    Value<int>? id,
    Value<String>? membershipId,
    Value<String?>? membershipStart,
    Value<String?>? membershipOver,
    Value<String>? membershipStatus,
  }) {
    return CachedMembershipsCompanion(
      id: id ?? this.id,
      membershipId: membershipId ?? this.membershipId,
      membershipStart: membershipStart ?? this.membershipStart,
      membershipOver: membershipOver ?? this.membershipOver,
      membershipStatus: membershipStatus ?? this.membershipStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (membershipId.present) {
      map['membership_id'] = Variable<String>(membershipId.value);
    }
    if (membershipStart.present) {
      map['membership_start'] = Variable<String>(membershipStart.value);
    }
    if (membershipOver.present) {
      map['membership_over'] = Variable<String>(membershipOver.value);
    }
    if (membershipStatus.present) {
      map['membership_status'] = Variable<String>(membershipStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedMembershipsCompanion(')
          ..write('id: $id, ')
          ..write('membershipId: $membershipId, ')
          ..write('membershipStart: $membershipStart, ')
          ..write('membershipOver: $membershipOver, ')
          ..write('membershipStatus: $membershipStatus')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedSessionsTable cachedSessions = $CachedSessionsTable(this);
  late final $CachedCompaniesTable cachedCompanies = $CachedCompaniesTable(
    this,
  );
  late final $CachedAreaCompaniesTable cachedAreaCompanies =
      $CachedAreaCompaniesTable(this);
  late final $CachedWorkTeamsTable cachedWorkTeams = $CachedWorkTeamsTable(
    this,
  );
  late final $SavedCardsTable savedCards = $SavedCardsTable(this);
  late final $CachedMembershipsTable cachedMemberships =
      $CachedMembershipsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedSessions,
    cachedCompanies,
    cachedAreaCompanies,
    cachedWorkTeams,
    savedCards,
    cachedMemberships,
  ];
}

typedef $$CachedSessionsTableCreateCompanionBuilder =
    CachedSessionsCompanion Function({
      Value<int> id,
      required String accessToken,
      required String userId,
    });
typedef $$CachedSessionsTableUpdateCompanionBuilder =
    CachedSessionsCompanion Function({
      Value<int> id,
      Value<String> accessToken,
      Value<String> userId,
    });

class $$CachedSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedSessionsTable> {
  $$CachedSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedSessionsTable> {
  $$CachedSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedSessionsTable> {
  $$CachedSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
}

class $$CachedSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedSessionsTable,
          CachedSessionRow,
          $$CachedSessionsTableFilterComposer,
          $$CachedSessionsTableOrderingComposer,
          $$CachedSessionsTableAnnotationComposer,
          $$CachedSessionsTableCreateCompanionBuilder,
          $$CachedSessionsTableUpdateCompanionBuilder,
          (
            CachedSessionRow,
            BaseReferences<
              _$AppDatabase,
              $CachedSessionsTable,
              CachedSessionRow
            >,
          ),
          CachedSessionRow,
          PrefetchHooks Function()
        > {
  $$CachedSessionsTableTableManager(
    _$AppDatabase db,
    $CachedSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> accessToken = const Value.absent(),
                Value<String> userId = const Value.absent(),
              }) => CachedSessionsCompanion(
                id: id,
                accessToken: accessToken,
                userId: userId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String accessToken,
                required String userId,
              }) => CachedSessionsCompanion.insert(
                id: id,
                accessToken: accessToken,
                userId: userId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedSessionsTable,
      CachedSessionRow,
      $$CachedSessionsTableFilterComposer,
      $$CachedSessionsTableOrderingComposer,
      $$CachedSessionsTableAnnotationComposer,
      $$CachedSessionsTableCreateCompanionBuilder,
      $$CachedSessionsTableUpdateCompanionBuilder,
      (
        CachedSessionRow,
        BaseReferences<_$AppDatabase, $CachedSessionsTable, CachedSessionRow>,
      ),
      CachedSessionRow,
      PrefetchHooks Function()
    >;
typedef $$CachedCompaniesTableCreateCompanionBuilder =
    CachedCompaniesCompanion Function({
      required String companyId,
      required String name,
      required String ruc,
      required String contactEmail,
      required String contactPhone,
      Value<int> rowid,
    });
typedef $$CachedCompaniesTableUpdateCompanionBuilder =
    CachedCompaniesCompanion Function({
      Value<String> companyId,
      Value<String> name,
      Value<String> ruc,
      Value<String> contactEmail,
      Value<String> contactPhone,
      Value<int> rowid,
    });

class $$CachedCompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCompaniesTable> {
  $$CachedCompaniesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruc => $composableBuilder(
    column: $table.ruc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPhone => $composableBuilder(
    column: $table.contactPhone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCompaniesTable> {
  $$CachedCompaniesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get companyId => $composableBuilder(
    column: $table.companyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruc => $composableBuilder(
    column: $table.ruc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPhone => $composableBuilder(
    column: $table.contactPhone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCompaniesTable> {
  $$CachedCompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get companyId =>
      $composableBuilder(column: $table.companyId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get ruc =>
      $composableBuilder(column: $table.ruc, builder: (column) => column);

  GeneratedColumn<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactPhone => $composableBuilder(
    column: $table.contactPhone,
    builder: (column) => column,
  );
}

class $$CachedCompaniesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCompaniesTable,
          CachedCompanyRow,
          $$CachedCompaniesTableFilterComposer,
          $$CachedCompaniesTableOrderingComposer,
          $$CachedCompaniesTableAnnotationComposer,
          $$CachedCompaniesTableCreateCompanionBuilder,
          $$CachedCompaniesTableUpdateCompanionBuilder,
          (
            CachedCompanyRow,
            BaseReferences<
              _$AppDatabase,
              $CachedCompaniesTable,
              CachedCompanyRow
            >,
          ),
          CachedCompanyRow,
          PrefetchHooks Function()
        > {
  $$CachedCompaniesTableTableManager(
    _$AppDatabase db,
    $CachedCompaniesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCompaniesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCompaniesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> companyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> ruc = const Value.absent(),
                Value<String> contactEmail = const Value.absent(),
                Value<String> contactPhone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCompaniesCompanion(
                companyId: companyId,
                name: name,
                ruc: ruc,
                contactEmail: contactEmail,
                contactPhone: contactPhone,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String companyId,
                required String name,
                required String ruc,
                required String contactEmail,
                required String contactPhone,
                Value<int> rowid = const Value.absent(),
              }) => CachedCompaniesCompanion.insert(
                companyId: companyId,
                name: name,
                ruc: ruc,
                contactEmail: contactEmail,
                contactPhone: contactPhone,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCompaniesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCompaniesTable,
      CachedCompanyRow,
      $$CachedCompaniesTableFilterComposer,
      $$CachedCompaniesTableOrderingComposer,
      $$CachedCompaniesTableAnnotationComposer,
      $$CachedCompaniesTableCreateCompanionBuilder,
      $$CachedCompaniesTableUpdateCompanionBuilder,
      (
        CachedCompanyRow,
        BaseReferences<_$AppDatabase, $CachedCompaniesTable, CachedCompanyRow>,
      ),
      CachedCompanyRow,
      PrefetchHooks Function()
    >;
typedef $$CachedAreaCompaniesTableCreateCompanionBuilder =
    CachedAreaCompaniesCompanion Function({
      required String areaCompanyId,
      required String name,
      required int annualBudget,
      Value<int> rowid,
    });
typedef $$CachedAreaCompaniesTableUpdateCompanionBuilder =
    CachedAreaCompaniesCompanion Function({
      Value<String> areaCompanyId,
      Value<String> name,
      Value<int> annualBudget,
      Value<int> rowid,
    });

class $$CachedAreaCompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedAreaCompaniesTable> {
  $$CachedAreaCompaniesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get areaCompanyId => $composableBuilder(
    column: $table.areaCompanyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get annualBudget => $composableBuilder(
    column: $table.annualBudget,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedAreaCompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedAreaCompaniesTable> {
  $$CachedAreaCompaniesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get areaCompanyId => $composableBuilder(
    column: $table.areaCompanyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get annualBudget => $composableBuilder(
    column: $table.annualBudget,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedAreaCompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedAreaCompaniesTable> {
  $$CachedAreaCompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get areaCompanyId => $composableBuilder(
    column: $table.areaCompanyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get annualBudget => $composableBuilder(
    column: $table.annualBudget,
    builder: (column) => column,
  );
}

class $$CachedAreaCompaniesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedAreaCompaniesTable,
          CachedAreaCompanyRow,
          $$CachedAreaCompaniesTableFilterComposer,
          $$CachedAreaCompaniesTableOrderingComposer,
          $$CachedAreaCompaniesTableAnnotationComposer,
          $$CachedAreaCompaniesTableCreateCompanionBuilder,
          $$CachedAreaCompaniesTableUpdateCompanionBuilder,
          (
            CachedAreaCompanyRow,
            BaseReferences<
              _$AppDatabase,
              $CachedAreaCompaniesTable,
              CachedAreaCompanyRow
            >,
          ),
          CachedAreaCompanyRow,
          PrefetchHooks Function()
        > {
  $$CachedAreaCompaniesTableTableManager(
    _$AppDatabase db,
    $CachedAreaCompaniesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAreaCompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedAreaCompaniesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedAreaCompaniesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> areaCompanyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> annualBudget = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAreaCompaniesCompanion(
                areaCompanyId: areaCompanyId,
                name: name,
                annualBudget: annualBudget,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String areaCompanyId,
                required String name,
                required int annualBudget,
                Value<int> rowid = const Value.absent(),
              }) => CachedAreaCompaniesCompanion.insert(
                areaCompanyId: areaCompanyId,
                name: name,
                annualBudget: annualBudget,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedAreaCompaniesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedAreaCompaniesTable,
      CachedAreaCompanyRow,
      $$CachedAreaCompaniesTableFilterComposer,
      $$CachedAreaCompaniesTableOrderingComposer,
      $$CachedAreaCompaniesTableAnnotationComposer,
      $$CachedAreaCompaniesTableCreateCompanionBuilder,
      $$CachedAreaCompaniesTableUpdateCompanionBuilder,
      (
        CachedAreaCompanyRow,
        BaseReferences<
          _$AppDatabase,
          $CachedAreaCompaniesTable,
          CachedAreaCompanyRow
        >,
      ),
      CachedAreaCompanyRow,
      PrefetchHooks Function()
    >;
typedef $$CachedWorkTeamsTableCreateCompanionBuilder =
    CachedWorkTeamsCompanion Function({
      required String workTeamId,
      required String teamName,
      required String leaderOfTeam,
      required String unitOfWorkId,
      Value<int> rowid,
    });
typedef $$CachedWorkTeamsTableUpdateCompanionBuilder =
    CachedWorkTeamsCompanion Function({
      Value<String> workTeamId,
      Value<String> teamName,
      Value<String> leaderOfTeam,
      Value<String> unitOfWorkId,
      Value<int> rowid,
    });

class $$CachedWorkTeamsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedWorkTeamsTable> {
  $$CachedWorkTeamsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get workTeamId => $composableBuilder(
    column: $table.workTeamId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamName => $composableBuilder(
    column: $table.teamName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaderOfTeam => $composableBuilder(
    column: $table.leaderOfTeam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitOfWorkId => $composableBuilder(
    column: $table.unitOfWorkId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedWorkTeamsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedWorkTeamsTable> {
  $$CachedWorkTeamsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get workTeamId => $composableBuilder(
    column: $table.workTeamId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamName => $composableBuilder(
    column: $table.teamName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaderOfTeam => $composableBuilder(
    column: $table.leaderOfTeam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitOfWorkId => $composableBuilder(
    column: $table.unitOfWorkId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedWorkTeamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedWorkTeamsTable> {
  $$CachedWorkTeamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get workTeamId => $composableBuilder(
    column: $table.workTeamId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get teamName =>
      $composableBuilder(column: $table.teamName, builder: (column) => column);

  GeneratedColumn<String> get leaderOfTeam => $composableBuilder(
    column: $table.leaderOfTeam,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitOfWorkId => $composableBuilder(
    column: $table.unitOfWorkId,
    builder: (column) => column,
  );
}

class $$CachedWorkTeamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedWorkTeamsTable,
          CachedWorkTeamRow,
          $$CachedWorkTeamsTableFilterComposer,
          $$CachedWorkTeamsTableOrderingComposer,
          $$CachedWorkTeamsTableAnnotationComposer,
          $$CachedWorkTeamsTableCreateCompanionBuilder,
          $$CachedWorkTeamsTableUpdateCompanionBuilder,
          (
            CachedWorkTeamRow,
            BaseReferences<
              _$AppDatabase,
              $CachedWorkTeamsTable,
              CachedWorkTeamRow
            >,
          ),
          CachedWorkTeamRow,
          PrefetchHooks Function()
        > {
  $$CachedWorkTeamsTableTableManager(
    _$AppDatabase db,
    $CachedWorkTeamsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedWorkTeamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedWorkTeamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedWorkTeamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> workTeamId = const Value.absent(),
                Value<String> teamName = const Value.absent(),
                Value<String> leaderOfTeam = const Value.absent(),
                Value<String> unitOfWorkId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedWorkTeamsCompanion(
                workTeamId: workTeamId,
                teamName: teamName,
                leaderOfTeam: leaderOfTeam,
                unitOfWorkId: unitOfWorkId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String workTeamId,
                required String teamName,
                required String leaderOfTeam,
                required String unitOfWorkId,
                Value<int> rowid = const Value.absent(),
              }) => CachedWorkTeamsCompanion.insert(
                workTeamId: workTeamId,
                teamName: teamName,
                leaderOfTeam: leaderOfTeam,
                unitOfWorkId: unitOfWorkId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedWorkTeamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedWorkTeamsTable,
      CachedWorkTeamRow,
      $$CachedWorkTeamsTableFilterComposer,
      $$CachedWorkTeamsTableOrderingComposer,
      $$CachedWorkTeamsTableAnnotationComposer,
      $$CachedWorkTeamsTableCreateCompanionBuilder,
      $$CachedWorkTeamsTableUpdateCompanionBuilder,
      (
        CachedWorkTeamRow,
        BaseReferences<_$AppDatabase, $CachedWorkTeamsTable, CachedWorkTeamRow>,
      ),
      CachedWorkTeamRow,
      PrefetchHooks Function()
    >;
typedef $$SavedCardsTableCreateCompanionBuilder =
    SavedCardsCompanion Function({
      Value<int> id,
      required String cardHolder,
      required String last4,
      required String expiryMonth,
      required String expiryYear,
      required String brand,
    });
typedef $$SavedCardsTableUpdateCompanionBuilder =
    SavedCardsCompanion Function({
      Value<int> id,
      Value<String> cardHolder,
      Value<String> last4,
      Value<String> expiryMonth,
      Value<String> expiryYear,
      Value<String> brand,
    });

class $$SavedCardsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedCardsTable> {
  $$SavedCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardHolder => $composableBuilder(
    column: $table.cardHolder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiryMonth => $composableBuilder(
    column: $table.expiryMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiryYear => $composableBuilder(
    column: $table.expiryYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedCardsTable> {
  $$SavedCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardHolder => $composableBuilder(
    column: $table.cardHolder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiryMonth => $composableBuilder(
    column: $table.expiryMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiryYear => $composableBuilder(
    column: $table.expiryYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedCardsTable> {
  $$SavedCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardHolder => $composableBuilder(
    column: $table.cardHolder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumn<String> get expiryMonth => $composableBuilder(
    column: $table.expiryMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expiryYear => $composableBuilder(
    column: $table.expiryYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);
}

class $$SavedCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedCardsTable,
          SavedCardRow,
          $$SavedCardsTableFilterComposer,
          $$SavedCardsTableOrderingComposer,
          $$SavedCardsTableAnnotationComposer,
          $$SavedCardsTableCreateCompanionBuilder,
          $$SavedCardsTableUpdateCompanionBuilder,
          (
            SavedCardRow,
            BaseReferences<_$AppDatabase, $SavedCardsTable, SavedCardRow>,
          ),
          SavedCardRow,
          PrefetchHooks Function()
        > {
  $$SavedCardsTableTableManager(_$AppDatabase db, $SavedCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cardHolder = const Value.absent(),
                Value<String> last4 = const Value.absent(),
                Value<String> expiryMonth = const Value.absent(),
                Value<String> expiryYear = const Value.absent(),
                Value<String> brand = const Value.absent(),
              }) => SavedCardsCompanion(
                id: id,
                cardHolder: cardHolder,
                last4: last4,
                expiryMonth: expiryMonth,
                expiryYear: expiryYear,
                brand: brand,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cardHolder,
                required String last4,
                required String expiryMonth,
                required String expiryYear,
                required String brand,
              }) => SavedCardsCompanion.insert(
                id: id,
                cardHolder: cardHolder,
                last4: last4,
                expiryMonth: expiryMonth,
                expiryYear: expiryYear,
                brand: brand,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedCardsTable,
      SavedCardRow,
      $$SavedCardsTableFilterComposer,
      $$SavedCardsTableOrderingComposer,
      $$SavedCardsTableAnnotationComposer,
      $$SavedCardsTableCreateCompanionBuilder,
      $$SavedCardsTableUpdateCompanionBuilder,
      (
        SavedCardRow,
        BaseReferences<_$AppDatabase, $SavedCardsTable, SavedCardRow>,
      ),
      SavedCardRow,
      PrefetchHooks Function()
    >;
typedef $$CachedMembershipsTableCreateCompanionBuilder =
    CachedMembershipsCompanion Function({
      Value<int> id,
      required String membershipId,
      Value<String?> membershipStart,
      Value<String?> membershipOver,
      required String membershipStatus,
    });
typedef $$CachedMembershipsTableUpdateCompanionBuilder =
    CachedMembershipsCompanion Function({
      Value<int> id,
      Value<String> membershipId,
      Value<String?> membershipStart,
      Value<String?> membershipOver,
      Value<String> membershipStatus,
    });

class $$CachedMembershipsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedMembershipsTable> {
  $$CachedMembershipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get membershipId => $composableBuilder(
    column: $table.membershipId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get membershipStart => $composableBuilder(
    column: $table.membershipStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get membershipOver => $composableBuilder(
    column: $table.membershipOver,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get membershipStatus => $composableBuilder(
    column: $table.membershipStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedMembershipsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedMembershipsTable> {
  $$CachedMembershipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get membershipId => $composableBuilder(
    column: $table.membershipId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get membershipStart => $composableBuilder(
    column: $table.membershipStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get membershipOver => $composableBuilder(
    column: $table.membershipOver,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get membershipStatus => $composableBuilder(
    column: $table.membershipStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedMembershipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedMembershipsTable> {
  $$CachedMembershipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get membershipId => $composableBuilder(
    column: $table.membershipId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get membershipStart => $composableBuilder(
    column: $table.membershipStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get membershipOver => $composableBuilder(
    column: $table.membershipOver,
    builder: (column) => column,
  );

  GeneratedColumn<String> get membershipStatus => $composableBuilder(
    column: $table.membershipStatus,
    builder: (column) => column,
  );
}

class $$CachedMembershipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedMembershipsTable,
          CachedMembershipRow,
          $$CachedMembershipsTableFilterComposer,
          $$CachedMembershipsTableOrderingComposer,
          $$CachedMembershipsTableAnnotationComposer,
          $$CachedMembershipsTableCreateCompanionBuilder,
          $$CachedMembershipsTableUpdateCompanionBuilder,
          (
            CachedMembershipRow,
            BaseReferences<
              _$AppDatabase,
              $CachedMembershipsTable,
              CachedMembershipRow
            >,
          ),
          CachedMembershipRow,
          PrefetchHooks Function()
        > {
  $$CachedMembershipsTableTableManager(
    _$AppDatabase db,
    $CachedMembershipsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedMembershipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedMembershipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedMembershipsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> membershipId = const Value.absent(),
                Value<String?> membershipStart = const Value.absent(),
                Value<String?> membershipOver = const Value.absent(),
                Value<String> membershipStatus = const Value.absent(),
              }) => CachedMembershipsCompanion(
                id: id,
                membershipId: membershipId,
                membershipStart: membershipStart,
                membershipOver: membershipOver,
                membershipStatus: membershipStatus,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String membershipId,
                Value<String?> membershipStart = const Value.absent(),
                Value<String?> membershipOver = const Value.absent(),
                required String membershipStatus,
              }) => CachedMembershipsCompanion.insert(
                id: id,
                membershipId: membershipId,
                membershipStart: membershipStart,
                membershipOver: membershipOver,
                membershipStatus: membershipStatus,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedMembershipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedMembershipsTable,
      CachedMembershipRow,
      $$CachedMembershipsTableFilterComposer,
      $$CachedMembershipsTableOrderingComposer,
      $$CachedMembershipsTableAnnotationComposer,
      $$CachedMembershipsTableCreateCompanionBuilder,
      $$CachedMembershipsTableUpdateCompanionBuilder,
      (
        CachedMembershipRow,
        BaseReferences<
          _$AppDatabase,
          $CachedMembershipsTable,
          CachedMembershipRow
        >,
      ),
      CachedMembershipRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedSessionsTableTableManager get cachedSessions =>
      $$CachedSessionsTableTableManager(_db, _db.cachedSessions);
  $$CachedCompaniesTableTableManager get cachedCompanies =>
      $$CachedCompaniesTableTableManager(_db, _db.cachedCompanies);
  $$CachedAreaCompaniesTableTableManager get cachedAreaCompanies =>
      $$CachedAreaCompaniesTableTableManager(_db, _db.cachedAreaCompanies);
  $$CachedWorkTeamsTableTableManager get cachedWorkTeams =>
      $$CachedWorkTeamsTableTableManager(_db, _db.cachedWorkTeams);
  $$SavedCardsTableTableManager get savedCards =>
      $$SavedCardsTableTableManager(_db, _db.savedCards);
  $$CachedMembershipsTableTableManager get cachedMemberships =>
      $$CachedMembershipsTableTableManager(_db, _db.cachedMemberships);
}
