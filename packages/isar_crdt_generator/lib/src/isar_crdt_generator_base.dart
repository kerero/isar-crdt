import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'package:isar_crdt/isar_crdt.dart';

import 'model_visitor.dart';

class CrdtCollectionGenerator extends GeneratorForAnnotation<CrdtCollection> {
  CrdtCollectionGenerator() : super() {
    print("was in constructor of $runtimeType");
  }

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = ModelVisitor();
    element.visitChildren(
        visitor); // Visits all the children of element in no particular order.
    final className = '${visitor.className}Gen'; // EX: 'ModelGen' for 'Model'.
    final classBuffer = StringBuffer();
    classBuffer.writeln('class $className extends ${visitor.className} {');
    classBuffer.writeln('Map<String, dynamic> variables = {};');
    classBuffer.writeln('$className() {');

    for (final field in visitor.fields.keys) {
      // remove '_' from private variables
      final variable =
          field.startsWith('_') ? field.replaceFirst('_', '') : field;

      classBuffer.writeln("variables['${variable}'] = super.$field;");
      // EX: variables['name'] = super._name;
    }

    classBuffer.writeln('}');
    generateGettersAndSetters(visitor, classBuffer);
    classBuffer.writeln('}');

    final s = classBuffer.toString();
    return s;
  }

  void generateGettersAndSetters(
      ModelVisitor visitor, StringBuffer classBuffer) {
    for (final field in visitor.fields.keys) {
      final variable =
          field.startsWith('_') ? field.replaceFirst('_', '') : field;
      classBuffer.writeln(
          "${visitor.fields[field]} get $variable => variables['$variable'];");
      // EX: String get name => variables['name'];
      classBuffer
          .writeln('set $variable(${visitor.fields[field]} $variable) {');
      classBuffer.writeln('super.$field = $variable;');
      classBuffer.writeln("variables['$variable'] = $variable;");
      classBuffer.writeln('}');

      // EX: set name(String name) {
      //       super._name = name;
      //       variables['name'] = name;
      //     }
    }
  }
}
