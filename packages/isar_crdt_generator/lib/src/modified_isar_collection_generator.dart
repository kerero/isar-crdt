// ignore_for_file: implementation_imports

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:isar_crdt/isar_crdt.dart';
import 'package:isar_generator/src/collection_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:isar_generator/src/isar_analyzer.dart';

class ModifiedIsarCollectionGenerator extends IsarCollectionGenerator {
  @override
  TypeChecker get typeChecker => TypeChecker.fromRuntime(CrdtCollection);

  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final object = IsarAnalyzer().analyzeCollection(element);
    final originalCollectionGetter = '''
      extension Get${object.dartName}Collection on Isar {
        IsarCollection<${object.dartName}> get ${object.accessor} => this.collection();
      }
''';

    final modifiedCollectionGetter = '''
      extension Get${object.dartName}Collection on Isar {
        IsarCrdtCollection<${object.dartName}> get ${object.accessor} => IsarCrdtCollection(this.collection());
      }
''';

    final s =
        await super.generateForAnnotatedElement(element, annotation, buildStep);
    if (!s.contains(originalCollectionGetter)) {
      throw Exception(
          "Collection Getter is not found. generator version is not compatible");
    }

    return s.replaceFirst(originalCollectionGetter, modifiedCollectionGetter);
  }
}
