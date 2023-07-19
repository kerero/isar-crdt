import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:isar_generator/src/collection_generator.dart';

import 'src/isar_crdt_generator_base.dart';

Builder generateCrdtCollection(BuilderOptions options) => PartBuilder(
      [
        CrdtCollectionGenerator(),
      ],
      '.crdt.dart',
    );

// Builder generateCollection(BuilderOptions options) => PartBuilder(
//       [IsarCollectionGenerator()],
//       'isar_collection_generator',
//     );
