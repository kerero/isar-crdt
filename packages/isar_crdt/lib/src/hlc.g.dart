// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hlc.dart';

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
