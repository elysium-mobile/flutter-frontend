// Namespace-collision policy: this file must import ONLY pure infrastructure
// and serialization packages. Flutter presentation packages (e.g.
// `package:flutter/material.dart`) export a `Table` widget that collides with
// Drift's `Table` schema base class. No layout-bound package is imported here;
// should one ever be required, it must be brought in with a `hide Table` clause
// so the Drift schema stays authoritative.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Clean schema definition modeling the persistent token-caching boundary.
///
/// Each row captures a single authenticated session so the shell can restore an
/// active login across cold starts without a network round-trip. The table is
/// intentionally minimal; it stores only the credential material required to
/// re-authorize outbound requests.
@DataClassName('CachedSessionRow')
class CachedSessions extends Table {
  /// Unique auto-incremented local identifier for the row mapping.
  ///
  /// Acts as the surrogate primary key; Drift derives the `PRIMARY KEY
  /// AUTOINCREMENT` constraint from [autoIncrement].
  IntColumn get id => integer().autoIncrement()();

  /// The authoritative access token string payload for the session.
  ///
  /// Stored verbatim as an opaque bearer credential; never `null`.
  TextColumn get accessToken => text()();

  /// Server-driven profile identifier associated with this login session.
  ///
  /// Correlates the cached credential with the owning user record; never
  /// `null`.
  TextColumn get userId => text()();
}

/// Local relational mirror of the companies tracked by the HR Analytics
/// dashboard.
///
/// Rows are refreshed from the ELYSIUM `/api/v1/companies` resource so the
/// dashboard can render the organizational hierarchy across cold starts and
/// transient network loss. Identifiers are stored verbatim as text.
@DataClassName('CachedCompanyRow')
class CachedCompanies extends Table {
  /// Server-driven company identifier; acts as the natural primary key.
  TextColumn get companyId => text()();

  /// Legal / commercial name of the company.
  TextColumn get name => text()();

  /// Peruvian tax identifier (RUC) of the company.
  TextColumn get ruc => text()();

  /// Primary contact email address for the company.
  TextColumn get contactEmail => text()();

  /// Primary contact phone number for the company.
  TextColumn get contactPhone => text()();

  @override
  Set<Column> get primaryKey => <Column>{companyId};
}

/// Local relational mirror of the functional areas tracked by the dashboard.
///
/// Rows are refreshed from the ELYSIUM `/api/v1/area-company` resource.
@DataClassName('CachedAreaCompanyRow')
class CachedAreaCompanies extends Table {
  /// Server-driven area identifier; acts as the natural primary key.
  TextColumn get areaCompanyId => text()();

  /// Human-readable name of the area.
  TextColumn get name => text()();

  /// Yearly operating budget allocated to the area.
  IntColumn get annualBudget => integer()();

  @override
  Set<Column> get primaryKey => <Column>{areaCompanyId};
}

/// Local relational mirror of the work teams assigned to the authenticated HR
/// specialist.
///
/// Rows are refreshed from the ELYSIUM `/api/v1/work-teams` resource and feed
/// the dashboard's "Choose team" selector.
@DataClassName('CachedWorkTeamRow')
class CachedWorkTeams extends Table {
  /// Server-driven work-team identifier; acts as the natural primary key.
  TextColumn get workTeamId => text()();

  /// Display name of the team.
  TextColumn get teamName => text()();

  /// Full name of the person leading the team.
  TextColumn get leaderOfTeam => text()();

  /// Identifier of the owning unit of work.
  TextColumn get unitOfWorkId => text()();

  @override
  Set<Column> get primaryKey => <Column>{workTeamId};
}

/// Local relational database access gateway built on the modern Drift ORM.
///
/// Backed by the pure `sqlite3` 3.x engine bundled through native build hooks —
/// the obsolete `sqlite3_flutter_libs` glue package is deliberately not
/// referenced anywhere in this compilation path.
@DriftDatabase(
  tables: [
    CachedSessions,
    CachedCompanies,
    CachedAreaCompanies,
    CachedWorkTeams,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Initializes the local database using the native sqlite3 configuration
  /// provided by [_openConnection].
  AppDatabase() : super(_openConnection());

  /// Current on-disk schema revision.
  ///
  /// Increment this and extend [migration] whenever the table structure
  /// changes. Revision `2` introduced the HR Analytics dashboard mirror tables.
  @override
  int get schemaVersion => 2;

  /// Forward-only migration plan for the local cache.
  ///
  /// Fresh installs create every table via [Migrator.createAll]; existing
  /// installs upgrading from schema `1` gain the dashboard mirror tables without
  /// discarding the cached session.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) => m.createAll(),
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(cachedCompanies);
            await m.createTable(cachedAreaCompanies);
            await m.createTable(cachedWorkTeams);
          }
        },
      );

  /// Persists [companion] as the single cached session, replacing any prior
  /// row so only the most recent session is retained.
  Future<void> cacheSession(CachedSessionsCompanion companion) {
    return transaction(() async {
      await delete(cachedSessions).go();
      await into(cachedSessions).insert(companion);
    });
  }

  /// Removes every cached session row (invoked on sign-out).
  Future<void> clearCachedSessions() => delete(cachedSessions).go();

  /// Returns the access token of the most recently cached session, or `null`
  /// when no session is cached. Consumed by the network client's bearer-token
  /// provider.
  Future<String?> readAccessToken() async {
    final query = select(cachedSessions)
      ..orderBy(<OrderingTerm Function($CachedSessionsTable)>[
        (t) => OrderingTerm.desc(t.id),
      ])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row?.accessToken;
  }

  /// Replaces the cached company mirror with [companions] in a single
  /// transaction, so a refresh never leaves partially-stale rows.
  Future<void> cacheCompanies(List<CachedCompaniesCompanion> companions) {
    return transaction(() async {
      await delete(cachedCompanies).go();
      await batch((Batch batch) {
        batch.insertAll(cachedCompanies, companions);
      });
    });
  }

  /// Returns every cached company row (used as an offline fallback).
  Future<List<CachedCompanyRow>> readCompanies() =>
      select(cachedCompanies).get();

  /// Replaces the cached area mirror with [companions] transactionally.
  Future<void> cacheAreaCompanies(
    List<CachedAreaCompaniesCompanion> companions,
  ) {
    return transaction(() async {
      await delete(cachedAreaCompanies).go();
      await batch((Batch batch) {
        batch.insertAll(cachedAreaCompanies, companions);
      });
    });
  }

  /// Returns every cached area row (used as an offline fallback).
  Future<List<CachedAreaCompanyRow>> readAreaCompanies() =>
      select(cachedAreaCompanies).get();

  /// Replaces the cached work-team mirror with [companions] transactionally.
  Future<void> cacheWorkTeams(List<CachedWorkTeamsCompanion> companions) {
    return transaction(() async {
      await delete(cachedWorkTeams).go();
      await batch((Batch batch) {
        batch.insertAll(cachedWorkTeams, companions);
      });
    });
  }

  /// Returns every cached work-team row (used as an offline fallback).
  Future<List<CachedWorkTeamRow>> readWorkTeams() =>
      select(cachedWorkTeams).get();
}

/// Provisions the native file-backed executor that opens the sqlite3 engine.
///
/// The connection is resolved lazily (via [LazyDatabase]) so the documents
/// directory is only queried on first use. Write operations run through
/// [NativeDatabase.createInBackground], which executes them on a separate
/// isolate — keeping database I/O decoupled from the primary UI thread loop.
QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'softwork_local_cache.db'));
    return NativeDatabase.createInBackground(file);
  });
}
