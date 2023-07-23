import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:isar_crdt/isar_crdt.dart';

class CrdtCollectionGenerator extends GeneratorForAnnotation<CrdtCollection> {
  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    element as ClassElement;

    var classCode = await generateClass(element, buildStep);
    // Remove the closing curly bracket from the class
    classCode = classCode.substring(0, classCode.length - 1);

    final className = element.displayName;

    return '''
      class ${getGeneratedClassName(element.displayName)} extends IsarCrdtBase {
        ${generateHlcFields(element)}
      }

      extension ${className}Hlc on IsarCollection<$className> {
          void updateHLCs(Id id, $className newObj) async {
          final oldObj = await get(id);

          ${generateHlcUpdates(element)}
        }
      }''';
  }

  Future<String> generateClass(
      ClassElement element, BuildStep buildStep) async {
    final astNode = await buildStep.resolver.astNodeFor(element);
    var code = astNode!.toSource();
    code = code.replaceFirst("@crdtCollection", "");
    code = code.replaceAll(
        element.displayName, getGeneratedClassName(element.displayName));

    return code;
  }

  String generateHlcFields(ClassElement element) {
    final s = StringBuffer();
    for (final f in element.fields.where((f) => !isIsarId(f))) {
      s.writeln("@protected");
      s.writeln("Hlc ${getHlcFieldName(f.displayName)} = Hlc.zero();");
      if (f.type.isDartCoreList) {
        s.writeln("@protected");
        s.writeln("List<Hlc> ${getListHlcFieldName(f.displayName)} = [];");
      }
    }

    return s.toString();
  }

  String generateHlcUpdates(ClassElement element) {
    final s = StringBuffer();
    final fields = element.fields.where((f) => !isIsarId(f));

    // generate primitives
    for (final f in fields.where((f) => isPrimitive(f.type))) {
      final fieldName = f.displayName;
      s.writeln(
          "newObj.${getHlcFieldName(fieldName)} = updateHlcPrimitives(oldObj?.$fieldName, newObj.$fieldName, oldObj?.${getHlcFieldName(fieldName)});");
    }

    // generate for primitive lists
    for (final f in fields.where((f) => f.type.isDartCoreList)) {
      final fieldName = f.displayName;
      s.writeln(
          "newObj.${getHlcFieldName(fieldName)} = updatePrimitiveListHlc(oldObj?.$fieldName, newObj.$fieldName, oldObj?.${getHlcFieldName(fieldName)}, oldObj?.${getListHlcFieldName(fieldName)});");
    }
    // TODO: generate for embedded

    return s.toString();
  }

  String getHlcFieldName(String varName) => "${varName}_fieldHlc";
  String getListHlcFieldName(String varName) => "${varName}_listHlc";

  String getGeneratedClassName(String name) => "_${name}Crdt";

  bool isIsarId(FieldElement f) => f.type.alias?.element.name == "Id";

  bool isPrimitive(DartType t) =>
      t.isDartCoreInt ||
      t.isDartCoreDouble ||
      t.isDartCoreString ||
      t.isDartCoreEnum ||
      t.isDartCoreBool ||
      t.isDartCoreNum;
}
