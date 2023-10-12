import 'package:isar_crdt/isar_crdt.dart';
import 'package:isar/isar.dart';
import 'test_embedded_class.dart';

part 'some_class.isar_crdt.g.dart';
part 'some_class.isar.g.dart';

@crdtCollection
@Collection(inheritance: true)
class SomeClass extends _SomeClassCrdt {
  int myInt;
  Id id = Isar.autoIncrement;
  double? myDouble;
  List<float> myFloatList = List.empty(growable: true);
  TestEmbeddedClass myEmbeddedClass = TestEmbeddedClass();
  AnotherTestEmbeddedClass myAnotherEmbeddedClass = AnotherTestEmbeddedClass();
  List<AnotherTestEmbeddedClass> myEmbeddedList = [];

  SomeClass(this.myInt);
}

extension TestClassExtensions on SomeClass {
  ///
  SomeClass withGrowableLists() => this
    ..myFloatList = myFloatList.toList()
    ..myEmbeddedList = myEmbeddedList.toList();
}

@embedded
@crdtEmbedded
class TestEmbeddedClass extends _TestEmbeddedClassCrdt {
  int? myOtherInt;
  float myOtherFloat = 0;
  List<double> myOtherDoubleList = [];
}
