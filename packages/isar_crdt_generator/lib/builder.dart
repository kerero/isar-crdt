import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:isar_generator/src/collection_generator.dart';

import 'src/crdt_collection_generator.dart';
import 'src/modified_isar_collection_generator.dart';

Builder generateIsarCrdt(BuilderOptions options) => PartBuilder(
      [
        CrdtCollectionGenerator(),
        ModifiedIsarCollectionGenerator(),
      ],
      '.isar_crdt.g.dart',
    );

Builder generateIsar(BuilderOptions options) => PartBuilder(
      [
        IsarCollectionGenerator(),
        IsarEmbeddedGenerator(),
      ],
      '.isar.g.dart',
    );
