import 'package:isar_crdt/isar_crdt.dart';
import 'package:isar_crdt_generator/src/crdt_collection_generator.dart';
import 'package:source_gen/source_gen.dart';

class CrdtEmbeddedGenerator extends CrdtCollectionGenerator {
  @override
  TypeChecker get typeChecker => const TypeChecker.fromRuntime(CrdtEmbedded);
}
