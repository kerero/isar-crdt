import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
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
    element.visitChildren(visitor);
    final code = '''
@collection
class Example{
  Id? id;
  int? myOtherInt;
}
''';

    return code;
  }
}
