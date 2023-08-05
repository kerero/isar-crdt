// ignore_for_file: implementation_imports

import 'package:isar_crdt/isar_crdt.dart';
import 'package:source_gen/source_gen.dart';
import 'crdt_collection_generator.dart';

class CrdtEmbeddedGenerator extends CrdtCollectionGenerator {
  @override
  TypeChecker get typeChecker => TypeChecker.fromRuntime(CrdtEmbedded);
}
