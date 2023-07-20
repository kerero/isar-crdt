import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/crdt_collection_generator.dart';

Builder generateCrdtCollection(BuilderOptions options) => PartBuilder(
      [
        CrdtCollectionGenerator(),
      ],
      '.isar_crdt.g.dart',
    );
