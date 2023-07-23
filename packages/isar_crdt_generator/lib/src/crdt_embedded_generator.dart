// ignore_for_file: implementation_imports

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:isar_crdt/isar_crdt.dart';
import 'package:source_gen/source_gen.dart';
import 'crdt_collection_generator.dart';

class CrdtEmbeddedGenerator extends CrdtCollectionGenerator {
  @override
  TypeChecker get typeChecker => TypeChecker.fromRuntime(CrdtEmbedded);

  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final s =
        await super.generateForAnnotatedElement(element, annotation, buildStep);

    return s;
  }
}
