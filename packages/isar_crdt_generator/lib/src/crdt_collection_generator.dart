import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:isar_crdt/isar_crdt.dart';

class CrdtCollectionGenerator extends GeneratorForAnnotation<CrdtCollection> {
  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    element as ClassElement;
    var classCode = await generateClass(element, buildStep);
    classCode = classCode.substring(0, classCode.length - 1);
    final code = '''
      $classCode
      ${generateHlcFields(element)}
      }
''';

    return code;
  }

  Future<String> generateClass(
      ClassElement element, BuildStep buildStep) async {
    final astNode = await buildStep.resolver.astNodeFor(element);
    var code = astNode!.toSource();
    code = code.replaceFirst("crdtCollection", "collection");
    code = code.replaceAll(element.displayName, "${element.displayName}Crdt");

    return code;
  }

  String generateHlcFields(ClassElement element) {
    final s = StringBuffer();
    // TODO: required id field to be named id
    for (final f in element.fields.where((f) => f.displayName != "id")) {
      s.writeln("Hlc ${f.displayName}Hlc = Hlc.zero();");
    }

    return s.toString();
  }
}
