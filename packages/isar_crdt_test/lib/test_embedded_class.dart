import 'package:isar/isar.dart';
import 'package:isar_crdt/isar_crdt.dart';

part 'test_embedded_class.isar.g.dart';
part 'test_embedded_class.isar_crdt.g.dart';

@Embedded(inheritance: true)
@crdtEmbedded
class AnotherTestEmbeddedClass extends _AnotherTestEmbeddedClassCrdt {
  int? myOtherInt;
  float myOtherFloat = 0;
  List<double> myOtherDoubleList = List.empty(growable: true);
}
