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
@DataClassName('CachedSession')
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

/// Local relational database access gateway built on the modern Drift ORM.
///
/// Backed by the pure `sqlite3` 3.x engine bundled through native build hooks —
/// the obsolete `sqlite3_flutter_libs` glue package is deliberately not
/// referenced anywhere in this compilation path.
@DriftDatabase(tables: [CachedSessions])
class AppDatabase extends _$AppDatabase {
  /// Initializes the local database using the native sqlite3 configuration
  /// provided by [_openConnection].
  AppDatabase() : super(_openConnection());

  /// Current on-disk schema revision.
  ///
  /// Increment this and provide a migration strategy whenever the table
  /// structure changes.
  @override
  int get schemaVersion => 1;
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
