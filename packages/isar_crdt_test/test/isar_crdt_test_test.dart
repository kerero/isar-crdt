import 'package:isar/isar.dart';
import 'package:isar_crdt/isar_crdt.dart';
import 'package:test/test.dart';

part 'isar_crdt_test_test.isar.g.dart';
part 'isar_crdt_test_test.isar_crdt.g.dart';

@collection
@crdtCollection
class SomeOtherTestClass extends _SomeOtherTestClassCrdt {
  Id id = Isar.autoIncrement;
  int c;
  SomeOtherTestClass(this.c);
}

void main() {
  test('calculate', () {
    SomeOtherTestClass a;
  });
}
