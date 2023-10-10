// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_system_hlc.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalSystemHlcStoreCollection on Isar {
  IsarCollection<LocalSystemHlcStore> get _localSystemHlcStore =>
      this.collection();
}

const LocalSystemHlcStoreSchema = CollectionSchema(
  name: r'LocalSystemHlcStore',
  id: -264398294228782069,
  properties: {
    r'storedHlc': PropertySchema(
      id: 0,
      name: r'storedHlc',
      type: IsarType.object,
      target: r'Hlc',
    )
  },
  estimateSize: _localSystemHlcStoreEstimateSize,
  serialize: _localSystemHlcStoreSerialize,
  deserialize: _localSystemHlcStoreDeserialize,
  deserializeProp: _localSystemHlcStoreDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'Hlc': HlcSchema},
  getId: _localSystemHlcStoreGetId,
  getLinks: _localSystemHlcStoreGetLinks,
  attach: _localSystemHlcStoreAttach,
  version: '3.1.0+1',
);

int _localSystemHlcStoreEstimateSize(
  LocalSystemHlcStore object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.storedHlc;
    if (value != null) {
      bytesCount +=
          3 + HlcSchema.estimateSize(value, allOffsets[Hlc]!, allOffsets);
    }
  }
  return bytesCount;
}

void _localSystemHlcStoreSerialize(
  LocalSystemHlcStore object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<Hlc>(
    offsets[0],
    allOffsets,
    HlcSchema.serialize,
    object.storedHlc,
  );
}

LocalSystemHlcStore _localSystemHlcStoreDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalSystemHlcStore(
    reader.readObjectOrNull<Hlc>(
      offsets[0],
      HlcSchema.deserialize,
      allOffsets,
    ),
  );
  object.id = id;
  return object;
}

P _localSystemHlcStoreDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<Hlc>(
        offset,
        HlcSchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localSystemHlcStoreGetId(LocalSystemHlcStore object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localSystemHlcStoreGetLinks(
    LocalSystemHlcStore object) {
  return [];
}

void _localSystemHlcStoreAttach(
    IsarCollection<dynamic> col, Id id, LocalSystemHlcStore object) {
  object.id = id;
}

extension LocalSystemHlcStoreQueryWhereSort
    on QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QWhere> {
  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalSystemHlcStoreQueryWhere
    on QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QWhereClause> {
  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalSystemHlcStoreQueryFilter on QueryBuilder<LocalSystemHlcStore,
    LocalSystemHlcStore, QFilterCondition> {
  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterFilterCondition>
      storedHlcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'storedHlc',
      ));
    });
  }

  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterFilterCondition>
      storedHlcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'storedHlc',
      ));
    });
  }
}

extension LocalSystemHlcStoreQueryObject on QueryBuilder<LocalSystemHlcStore,
    LocalSystemHlcStore, QFilterCondition> {
  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterFilterCondition>
      storedHlc(FilterQuery<Hlc> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'storedHlc');
    });
  }
}

extension LocalSystemHlcStoreQueryLinks on QueryBuilder<LocalSystemHlcStore,
    LocalSystemHlcStore, QFilterCondition> {}

extension LocalSystemHlcStoreQuerySortBy
    on QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QSortBy> {}

extension LocalSystemHlcStoreQuerySortThenBy
    on QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QSortThenBy> {
  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension LocalSystemHlcStoreQueryWhereDistinct
    on QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QDistinct> {}

extension LocalSystemHlcStoreQueryProperty
    on QueryBuilder<LocalSystemHlcStore, LocalSystemHlcStore, QQueryProperty> {
  QueryBuilder<LocalSystemHlcStore, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalSystemHlcStore, Hlc?, QQueryOperations>
      storedHlcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'storedHlc');
    });
  }
}
