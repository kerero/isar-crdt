// ignore_for_file: lines_longer_than_80_chars

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:isar_crdt/isar_crdt.dart';
import 'package:source_gen/source_gen.dart';

class CrdtCollectionGenerator extends GeneratorForAnnotation<CrdtCollection> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    element as ClassElement;

    var classCode = await _generateClass(element, buildStep);
    // Remove the closing curly bracket from the class
    classCode = classCode.substring(0, classCode.length - 1);

    final className = element.displayName;
    // TODO(kerero): think about removing class and embedded HLCs since they seem redundant
    return '''
      // ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member, , duplicate_ignore
      abstract class ${_getGeneratedClassName(element.displayName)} extends IsarCrdtBase<$className> {
        ${_generateHlcFields(element)}

        @protected
        @override
        Hlc updateHLCs($className? oldObj) {
          final newObj = this as $className;
          ${_generateHlcUpdateMethod(element)}
        }

        @protected
        @override
        void merge($className other) {
          ${_generateMergeMethod(element)}
        }
      }
      ''';
  }

  Future<String> _generateClass(
    ClassElement element,
    BuildStep buildStep,
  ) async {
    final astNode = await buildStep.resolver.astNodeFor(element);
    var code = astNode!.toSource();
    code = code.replaceFirst('@crdtCollection', '');
    code = code.replaceAll(
      element.displayName,
      _getGeneratedClassName(element.displayName),
    );

    return code;
  }

  String _generateHlcFields(ClassElement element) {
    final s = StringBuffer();
    final hlcFields = <String>[];

    s
      ..writeln('@protected')
      ..writeln('Hlc ${_getClassHlcName(element.displayName)} = Hlc.zero();');

    for (final f in element.fields.where((f) => !_isIsarId(f.type))) {
      s
        ..writeln('@protected')
        ..writeln('Hlc ${_getHlcFieldName(f.displayName)} = Hlc.zero();');
      hlcFields.add(_getHlcFieldName(f.displayName));
      if (f.type.isDartCoreList) {
        s
          ..writeln('@protected')
          ..writeln('List<Hlc> ${_getListHlcFieldName(f.displayName)} = [];');
      }
    }

    s.writeln('''
      @protected
      Hlc getLatestHlc() {
        return [${hlcFields.join(",")}].reduce((a, b) => a > b ? a :b);
      }
    ''');

    return s.toString();
  }

  String _generateHlcUpdateMethod(ClassElement element) {
    final s = StringBuffer();
    final fields = element.fields.where((f) => !_isIsarId(f.type));

    // generate for primitives
    for (final f in fields.where((f) => _isPrimitive(f.type))) {
      final fieldName = f.displayName;
      s.writeln(
        'newObj.${_getHlcFieldName(fieldName)} = updatePrimitivesHlc(oldObj?.$fieldName, newObj.$fieldName, oldObj?.${_getHlcFieldName(fieldName)});',
      );
    }

    // generate for lists
    for (final f in fields.where((f) => f.type.isDartCoreList)) {
      final fieldName = f.displayName;
      s
        ..writeln(
          'final ${fieldName}HlcRecord = updateListHlc(oldObj?.$fieldName, newObj.$fieldName, oldObj?.${_getHlcFieldName(fieldName)}, oldObj?.${_getListHlcFieldName(fieldName)});',
        )
        ..writeln(
          'newObj.${_getHlcFieldName(fieldName)} = ${fieldName}HlcRecord.\$1;',
        )
        ..writeln(
          'newObj.${_getListHlcFieldName(fieldName)} =  ${fieldName}HlcRecord.\$2;',
        );
    }
    // generate for embedded
    for (final f in fields
        .where((f) => _embeddedChecker.hasAnnotationOf(f.type.element!))) {
      final fieldName = f.displayName;
      s.writeln(
        'newObj.${_getHlcFieldName(fieldName)} = newObj.$fieldName.updateHLCs(oldObj?.$fieldName);',
      );
    }

    // Update class Hlc
    s
      ..writeln('${_getClassHlcName(element.displayName)} = getLatestHlc();')
      ..writeln('return ${_getClassHlcName(element.displayName)};');

    return s.toString();
  }

  String _generateMergeMethod(ClassElement element) {
    final s = StringBuffer();
    final fields = element.fields.where((f) => !_isIsarId(f.type));
    // final isarIdField = element.fields.firstWhere((f) => isIsarId(f.type));

    s.writeln('final self = this as ${element.displayName};');

    final classHlcFieldName = _getClassHlcName(element.displayName);
    s.writeln(
      'self.$classHlcFieldName = other.$classHlcFieldName > self.$classHlcFieldName ? other.$classHlcFieldName : self.$classHlcFieldName;',
    );

    // generate for primitives
    for (final f in fields.where((f) => _isPrimitive(f.type))) {
      final fieldName = f.displayName;
      final hlcFieldName = _getHlcFieldName(fieldName);
      s.writeln('''
                if(other.$hlcFieldName > self.$hlcFieldName){
                  self.$fieldName = other.$fieldName;
                  self.$hlcFieldName = other.$hlcFieldName;
                }''');
    }

    // generate for embedded
    for (final f in fields
        .where((f) => _embeddedChecker.hasAnnotationOf(f.type.element!))) {
      final fieldName = f.displayName;
      final hlcFieldName = _getHlcFieldName(fieldName);
      s
        ..writeln('self.$fieldName.merge(other.$fieldName);')
        ..writeln(
          'self.$hlcFieldName = other.$hlcFieldName > self.$hlcFieldName ? other.$hlcFieldName : self.$hlcFieldName;',
        );
    }

    // TODO(kerero): generate for lists

    return s.toString(); // TODO(kerero):
  }

  String _getHlcFieldName(String varName) => '${varName}_fieldHlc';
  String _getClassHlcName(String name) => '${name}_classHlc';
  String _getListHlcFieldName(String varName) => '${varName}_listHlc';

  String _getGeneratedClassName(String name) => '_${name}Crdt';
  static const TypeChecker _embeddedChecker =
      TypeChecker.fromRuntime(CrdtEmbedded);

  bool _isIsarId(DartType t) => t.alias?.element.name == 'Id';

  bool _isPrimitive(DartType t) =>
      t.isDartCoreInt ||
      t.isDartCoreDouble ||
      t.isDartCoreString ||
      t.isDartCoreEnum ||
      t.isDartCoreBool ||
      t.isDartCoreNum;
}
