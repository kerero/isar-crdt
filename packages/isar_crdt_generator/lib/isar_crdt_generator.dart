import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/isar_crdt_generator_base.dart';

Builder generateCrdtCollection(BuilderOptions options) => SharedPartBuilder(
      [
        CrdtCollectionGenerator(),
      ],
      'isar_crdt_generator',
    );
