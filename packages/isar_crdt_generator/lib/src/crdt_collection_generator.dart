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
    // TODO: think about removing class and embedded Hlcs since they seem redundant
    return '''
      // ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member, , duplicate_ignore
      abstract class ${getGeneratedClassName(element.displayName)} extends IsarCrdtBase<$className> {
        ${generateHlcFields(element)}

        @protected
        @override
        Hlc updateHLCs($className? oldObj) {
          final newObj = this as $className;
          ${generateHlcUpdateMethod(element)}
        }

        @protected
        @override
        void merge($className other) {
          ${generateMergeMethod(element)}
        }
      }
      ''';
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
    final hlcFields = [];

    s.writeln("@protected");
    s.writeln("Hlc ${getClassHlcName(element.displayName)} = Hlc.zero();");

    for (final f in element.fields.where((f) => !isIsarId(f.type))) {
      s.writeln("@protected");
      s.writeln("Hlc ${getHlcFieldName(f.displayName)} = Hlc.zero();");
      hlcFields.add(getHlcFieldName(f.displayName));
      if (f.type.isDartCoreList) {
        s.writeln("@protected");
        s.writeln("List<Hlc> ${getListHlcFieldName(f.displayName)} = [];");
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

  String generateHlcUpdateMethod(ClassElement element) {
    final s = StringBuffer();
    final fields = element.fields.where((f) => !isIsarId(f.type));

    // generate for primitives
    for (final f in fields.where((f) => isPrimitive(f.type))) {
      final fieldName = f.displayName;
      s.writeln(
          "newObj.${getHlcFieldName(fieldName)} = updatePrimitivesHlc(oldObj?.$fieldName, newObj.$fieldName, oldObj?.${getHlcFieldName(fieldName)});");
    }

    // generate for lists
    for (final f in fields.where((f) => f.type.isDartCoreList)) {
      final fieldName = f.displayName;
      s.writeln(
          "final ${fieldName}HlcRecord = updateListHlc(oldObj?.$fieldName, newObj.$fieldName, oldObj?.${getHlcFieldName(fieldName)}, oldObj?.${getListHlcFieldName(fieldName)});");
      s.writeln(
          "newObj.${getHlcFieldName(fieldName)} = ${fieldName}HlcRecord.\$1;");
      s.writeln(
          "newObj.${getListHlcFieldName(fieldName)} =  ${fieldName}HlcRecord.\$2;");
    }
    // generate for embedded
    for (final f in fields
        .where((f) => _embeddedChecker.hasAnnotationOf(f.type.element!))) {
      final fieldName = f.displayName;
      s.writeln(
          "newObj.${getHlcFieldName(fieldName)} = newObj.$fieldName.updateHLCs(oldObj?.$fieldName);");
    }

    // Update class Hlc
    s.writeln("${getClassHlcName(element.displayName)} = getLatestHlc();");
    s.writeln("return ${getClassHlcName(element.displayName)};");

    return s.toString();
  }

  String generateMergeMethod(ClassElement element) {
    final s = StringBuffer();
    final fields = element.fields.where((f) => !isIsarId(f.type));
    // final isarIdField = element.fields.firstWhere((f) => isIsarId(f.type));

    s.writeln('final self = this as ${element.displayName};');

    final classHlcFieldName = getClassHlcName(element.displayName);
    s.writeln(
        'self.$classHlcFieldName = other.$classHlcFieldName > self.$classHlcFieldName ? other.$classHlcFieldName : self.$classHlcFieldName;');

    // generate for primitives
    for (final f in fields.where((f) => f.type.isDartCoreList)) {
      final fieldName = f.displayName;
      final hlcFieldName = getHlcFieldName(fieldName);
      s.writeln('''
                self.$fieldName = other.$hlcFieldName > self.$hlcFieldName ? other.$fieldName : self.$fieldName;
                self.$hlcFieldName = other.$hlcFieldName > self.$hlcFieldName ? other.$hlcFieldName : self.$hlcFieldName;
                ''');
    }

    // generate for embedded
    for (final f in fields
        .where((f) => _embeddedChecker.hasAnnotationOf(f.type.element!))) {
      final fieldName = f.displayName;
      final hlcFieldName = getHlcFieldName(fieldName);
      s.writeln('self.$fieldName.merge(other.$fieldName);');
      s.writeln(
          'self.$hlcFieldName = other.$hlcFieldName > self.$hlcFieldName ? other.$hlcFieldName : self.$hlcFieldName;');
    }

    //TODO: generate for lists
    

    return s.toString(); // TODO:
  }

  String getHlcFieldName(String varName) => "${varName}_fieldHlc";
  String getClassHlcName(String name) => "${name}_classHlc";
  String getListHlcFieldName(String varName) => "${varName}_listHlc";

  String getGeneratedClassName(String name) => "_${name}Crdt";
  static const TypeChecker _embeddedChecker =
      TypeChecker.fromRuntime(CrdtEmbedded);

  bool isIsarId(DartType t) => t.alias?.element.name == "Id";

  bool isPrimitive(DartType t) =>
      t.isDartCoreInt ||
      t.isDartCoreDouble ||
      t.isDartCoreString ||
      t.isDartCoreEnum ||
      t.isDartCoreBool ||
      t.isDartCoreNum;
}
