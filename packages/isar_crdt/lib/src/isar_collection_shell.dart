import 'dart:typed_data';

import 'package:isar/isar.dart';

class IsarCollectionShell<OBJ> extends IsarCollection<OBJ> {
  IsarCollection<OBJ> originalCollection;

  IsarCollectionShell(this.originalCollection);

  @override
  Query<R> buildQuery<R>(
          {List<WhereClause> whereClauses = const [],
          bool whereDistinct = false,
          Sort whereSort = Sort.asc,
          FilterOperation? filter,
          List<SortProperty> sortBy = const [],
          List<DistinctProperty> distinctBy = const [],
          int? offset,
          int? limit,
          String? property}) =>
      originalCollection.buildQuery(
          distinctBy: distinctBy,
          filter: filter,
          limit: limit,
          offset: offset,
          property: property,
          sortBy: sortBy,
          whereClauses: whereClauses,
          whereDistinct: whereDistinct,
          whereSort: whereSort);

  @override
  Future<void> clear() => originalCollection.clear();

  @override
  void clearSync() => originalCollection.clearSync();
  @override
  Future<int> count() => originalCollection.count();

  @override
  int countSync() => originalCollection.countSync();

  @override
  Future<int> deleteAll(List<Id> ids) => originalCollection.deleteAll(ids);

  @override
  Future<int> deleteAllByIndex(String indexName, List<IndexKey> keys) =>
      originalCollection.deleteAllByIndex(indexName, keys);
  @override
  int deleteAllByIndexSync(String indexName, List<IndexKey> keys) =>
      originalCollection.deleteAllByIndexSync(indexName, keys);

  @override
  int deleteAllSync(List<Id> ids) => originalCollection.deleteAllSync(ids);

  @override
  Future<List<OBJ?>> getAll(List<Id> ids) => originalCollection.getAll(ids);

  @override
  Future<List<OBJ?>> getAllByIndex(String indexName, List<IndexKey> keys) =>
      originalCollection.getAllByIndex(indexName, keys);

  @override
  List<OBJ?> getAllByIndexSync(String indexName, List<IndexKey> keys) =>
      originalCollection.getAllByIndexSync(indexName, keys);

  @override
  List<OBJ?> getAllSync(List<Id> ids) => originalCollection.getAllSync(ids);

  @override
  Future<int> getSize(
          {bool includeIndexes = false, bool includeLinks = false}) =>
      originalCollection.getSize(
          includeIndexes: includeIndexes, includeLinks: includeLinks);

  @override
  int getSizeSync({bool includeIndexes = false, bool includeLinks = false}) =>
      originalCollection.getSizeSync(
          includeIndexes: includeIndexes, includeLinks: includeLinks);

  @override
  Future<void> importJson(List<Map<String, dynamic>> json) =>
      originalCollection.importJson(json);

  @override
  Future<void> importJsonRaw(Uint8List jsonBytes) =>
      originalCollection.importJsonRaw(jsonBytes);

  @override
  void importJsonRawSync(Uint8List jsonBytes) =>
      originalCollection.importJsonRawSync(jsonBytes);

  @override
  void importJsonSync(List<Map<String, dynamic>> json) =>
      originalCollection.importJsonSync(json);

  @override
  Isar get isar => originalCollection.isar;

  @override
  Future<Id> put(OBJ object) {
    return putAll([object]).then((List<Id> ids) => ids[0]);
  }

  @override
  Future<List<Id>> putAll(List<OBJ> objects) =>
      originalCollection.putAll(objects);

  @override
  Future<List<Id>> putAllByIndex(String indexName, List<OBJ> objects) =>
      originalCollection.putAllByIndex(indexName, objects);

  @override
  List<Id> putAllByIndexSync(String indexName, List<OBJ> objects,
          {bool saveLinks = true}) =>
      originalCollection.putAllByIndexSync(indexName, objects,
          saveLinks: saveLinks);

  @override
  List<Id> putAllSync(List<OBJ> objects, {bool saveLinks = true}) =>
      originalCollection.putAllSync(objects, saveLinks: saveLinks);

  @override
  CollectionSchema<OBJ> get schema => originalCollection.schema;

  @override
  // ignore: invalid_use_of_visible_for_testing_member
  Future<void> verify(List<OBJ> objects) => originalCollection.verify(objects);

  @override
  Future<void> verifyLink(
          String linkName, List<int> sourceIds, List<int> targetIds) =>
      // ignore: invalid_use_of_visible_for_testing_member
      originalCollection.verifyLink(linkName, sourceIds, targetIds);

  @override
  Stream<void> watchLazy({bool fireImmediately = false}) =>
      originalCollection.watchLazy(fireImmediately: fireImmediately);

  @override
  Stream<OBJ?> watchObject(Id id, {bool fireImmediately = false}) =>
      originalCollection.watchObject(id, fireImmediately: fireImmediately);

  @override
  Stream<void> watchObjectLazy(Id id, {bool fireImmediately = false}) =>
      originalCollection.watchObjectLazy(id, fireImmediately: fireImmediately);
}
