// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hlc.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalSystemHlcCollection on Isar {
  IsarCollection<LocalSystemHlc> get _localSystemHlc => this.collection();
}

const LocalSystemHlcSchema = CollectionSchema(
  name: r'LocalSystemHlc',
  id: 5949527600501192947,
  properties: {
    r'instanceHlc': PropertySchema(
      id: 0,
      name: r'instanceHlc',
      type: IsarType.object,
      target: r'Hlc',
    )
  },
  estimateSize: _localSystemHlcEstimateSize,
  serialize: _localSystemHlcSerialize,
  deserialize: _localSystemHlcDeserialize,
  deserializeProp: _localSystemHlcDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'Hlc': HlcSchema},
  getId: _localSystemHlcGetId,
  getLinks: _localSystemHlcGetLinks,
  attach: _localSystemHlcAttach,
  version: '3.1.0+1',
);

int _localSystemHlcEstimateSize(
  LocalSystemHlc object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.instanceHlc;
    if (value != null) {
      bytesCount +=
          3 + HlcSchema.estimateSize(value, allOffsets[Hlc]!, allOffsets);
    }
  }
  return bytesCount;
}

void _localSystemHlcSerialize(
  LocalSystemHlc object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<Hlc>(
    offsets[0],
    allOffsets,
    HlcSchema.serialize,
    object.instanceHlc,
  );
}

LocalSystemHlc _localSystemHlcDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalSystemHlc(
    reader.readObjectOrNull<Hlc>(
      offsets[0],
      HlcSchema.deserialize,
      allOffsets,
    ),
  );
  object.id = id;
  return object;
}

P _localSystemHlcDeserializeProp<P>(
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

Id _localSystemHlcGetId(LocalSystemHlc object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localSystemHlcGetLinks(LocalSystemHlc object) {
  return [];
}

void _localSystemHlcAttach(
    IsarCollection<dynamic> col, Id id, LocalSystemHlc object) {
  object.id = id;
}

extension LocalSystemHlcQueryWhereSort
    on QueryBuilder<LocalSystemHlc, LocalSystemHlc, QWhere> {
  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalSystemHlcQueryWhere
    on QueryBuilder<LocalSystemHlc, LocalSystemHlc, QWhereClause> {
  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterWhereClause> idBetween(
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

extension LocalSystemHlcQueryFilter
    on QueryBuilder<LocalSystemHlc, LocalSystemHlc, QFilterCondition> {
  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterFilterCondition>
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

  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterFilterCondition>
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

  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterFilterCondition>
      instanceHlcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'instanceHlc',
      ));
    });
  }

  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterFilterCondition>
      instanceHlcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'instanceHlc',
      ));
    });
  }
}

extension LocalSystemHlcQueryObject
    on QueryBuilder<LocalSystemHlc, LocalSystemHlc, QFilterCondition> {
  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterFilterCondition>
      instanceHlc(FilterQuery<Hlc> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'instanceHlc');
    });
  }
}

extension LocalSystemHlcQueryLinks
    on QueryBuilder<LocalSystemHlc, LocalSystemHlc, QFilterCondition> {}

extension LocalSystemHlcQuerySortBy
    on QueryBuilder<LocalSystemHlc, LocalSystemHlc, QSortBy> {}

extension LocalSystemHlcQuerySortThenBy
    on QueryBuilder<LocalSystemHlc, LocalSystemHlc, QSortThenBy> {
  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalSystemHlc, LocalSystemHlc, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension LocalSystemHlcQueryWhereDistinct
    on QueryBuilder<LocalSystemHlc, LocalSystemHlc, QDistinct> {}

extension LocalSystemHlcQueryProperty
    on QueryBuilder<LocalSystemHlc, LocalSystemHlc, QQueryProperty> {
  QueryBuilder<LocalSystemHlc, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalSystemHlc, Hlc?, QQueryOperations> instanceHlcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'instanceHlc');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const HlcSchema = Schema(
  name: r'Hlc',
  id: 9075703500916524150,
  properties: {
    r'hashCode': PropertySchema(
      id: 0,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'hybridTime': PropertySchema(
      id: 1,
      name: r'hybridTime',
      type: IsarType.long,
    ),
    r'nodeId': PropertySchema(
      id: 2,
      name: r'nodeId',
      type: IsarType.long,
    )
  },
  estimateSize: _hlcEstimateSize,
  serialize: _hlcSerialize,
  deserialize: _hlcDeserialize,
  deserializeProp: _hlcDeserializeProp,
);

int _hlcEstimateSize(
  Hlc object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _hlcSerialize(
  Hlc object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.hashCode);
  writer.writeLong(offsets[1], object.hybridTime);
  writer.writeLong(offsets[2], object.nodeId);
}

Hlc _hlcDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Hlc(
    hybridTime: reader.readLongOrNull(offsets[1]) ?? 0,
    nodeId: reader.readLongOrNull(offsets[2]) ?? Hlc.nullNodeId,
  );
  return object;
}

P _hlcDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? Hlc.nullNodeId) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension HlcQueryFilter on QueryBuilder<Hlc, Hlc, QFilterCondition> {
  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> hybridTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hybridTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> hybridTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hybridTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> hybridTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hybridTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> hybridTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hybridTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> nodeIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nodeId',
        value: value,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> nodeIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nodeId',
        value: value,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> nodeIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nodeId',
        value: value,
      ));
    });
  }

  QueryBuilder<Hlc, Hlc, QAfterFilterCondition> nodeIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nodeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HlcQueryObject on QueryBuilder<Hlc, Hlc, QFilterCondition> {}
