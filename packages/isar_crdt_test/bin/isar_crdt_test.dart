import 'package:isar/isar.dart';
import 'package:isar_crdt/isar_crdt.dart';
import 'package:isar_crdt_test/test_embedded_class.dart';
import 'package:isar_crdt_test/some_class.dart';

void main(List<String> arguments) async {
  await Isar.initializeIsarCore(download: true);
  final isar = await Isar.open([TestClassSchema, LocalSystemHlcStoreSchema],
      directory: '.');
  LocalSystemHlc.initializeSync(isar, 1);

  var obj = isar.testClass.getSync(1)?.withGrowableLists();
  if (obj == null) {
    obj = SomeClass(1);
    obj.myFloatList.addAll([1, 3, 4, 5]);
  } else {
    obj.myFloatList.add(333);
    obj.myInt = 2;
    obj.myFloatList[0] = 1337;
    obj.myEmbeddedList[0].myOtherFloat = 1.337;
  }
  obj.myEmbeddedList.add(AnotherTestEmbeddedClass());
  await isar.writeTxn(() {
    return isar.testClass.put(obj!);
  });
  await Future.delayed(Duration(days: 1));
}
