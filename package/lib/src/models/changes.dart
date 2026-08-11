import 'package:flutter_health_connect/src/enums/export.dart';
import 'package:flutter_health_connect/src/models/export.dart';
import 'package:flutter_health_connect/src/converters/export.dart';

/// Opaque Health Connect changes token used for incremental synchronization.
/// [ChangesToken] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [value]: The value of the token.
/// * [recordTypes]: The record types associated with this token.

class ChangesToken {
  const ChangesToken(this.value, {this.recordTypes = const []});

  final String value;
  final List<RecordType> recordTypes;

  Map<String, Object?> toMap() => {
    'token': value,
    'recordTypes': recordTypes.map((t) => t.name).toList(growable: false),
  };

  factory ChangesToken.fromMap(Map<Object?, Object?> map) {
    final types = (map['recordTypes'] as List<Object?>? ?? const [])
        .map((e) => RecordType.values.byName(e! as String))
        .toList(growable: false);
    return ChangesToken(map['token']! as String, recordTypes: types);
  }

  @override
  String toString() => 'ChangesToken(...)';
}

/// Incremental changes returned by Health Connect for a [ChangesToken].
/// [Changes] is a subclass of [BaseRecord].
///
/// ### Params
///
/// * [upsertedRecords]: The inserted or updated records.
/// * [deletedRecordIds]: The identifiers of the deleted records.
/// * [nextChangesToken]: The token to use for the next [getChanges] call.
/// * [hasMore]: Whether additional pages of changes remain.
/// * [changesTokenExpired]: Whether the previous token expired and a new one must be obtained.
class Changes {
  const Changes({
    required this.upsertedRecords,
    required this.deletedRecordIds,
    required this.nextChangesToken,
    required this.hasMore,
    required this.changesTokenExpired,
  });

  final List<BaseRecord> upsertedRecords;
  final List<String> deletedRecordIds;

  final ChangesToken nextChangesToken;
  final bool hasMore;
  final bool changesTokenExpired;

  factory Changes.fromMap(Map<Object?, Object?> map) {
    final upserts = (map['upsertedRecords'] as List<Object?>? ?? const [])
        .cast<Map<Object?, Object?>>()
        .map(RecordConverter.fromMap)
        .toList(growable: false);
    final deleted = (map['deletedRecordIds'] as List<Object?>? ?? const [])
        .cast<String>();
    return Changes(
      upsertedRecords: upserts,
      deletedRecordIds: deleted,
      nextChangesToken: ChangesToken.fromMap(
        (map['nextChangesToken'] as Map<Object?, Object?>?) ??
            {'token': map['nextToken'] as String? ?? ''},
      ),
      hasMore: map['hasMore'] as bool? ?? false,
      changesTokenExpired: map['changesTokenExpired'] as bool? ?? false,
    );
  }
}
