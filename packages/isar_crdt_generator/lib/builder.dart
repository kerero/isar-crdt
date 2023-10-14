import 'package:build/build.dart';
import 'package:isar_crdt_generator/src/crdt_collection_generator.dart';
import 'package:isar_crdt_generator/src/crdt_embedded_generator.dart';
import 'package:isar_crdt_generator/src/modified_isar_collection_generator.dart';
// ignore: implementation_imports
import 'package:isar_generator/src/collection_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder generateIsarCrdt(BuilderOptions options) => PartBuilder(
      [
        CrdtCollectionGenerator(),
        CrdtEmbeddedGenerator(),
        // ModifiedIsarCollectionGenerator(),
        // IsarEmbeddedGenerator(),
      ],
      '.isar_crdt.g.dart',
    );

Builder generateIsar(BuilderOptions options) => PartBuilder(
      [
        ModifiedIsarCollectionGenerator(),
        IsarEmbeddedGenerator(),
      ],
      '.isar.g.dart',
    );
