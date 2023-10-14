import 'dart:io';

import 'package:isar/isar.dart';
import 'package:isar_crdt/isar_crdt.dart';
import 'package:test/test.dart';

part 'merge_single_primitive_test.isar.g.dart';
part 'merge_single_primitive_test.isar_crdt.g.dart';

@collection
@crdtCollection
class SomeOtherTestClass extends _SomeOtherTestClassCrdt {
  SomeOtherTestClass(this.c);
  Id id = Isar.autoIncrement;
  int c;
}

void main() {
  late Isar isar;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open(
      [LocalSystemHlcStoreSchema, SomeOtherTestClassSchema],
      directory: Directory.systemTemp.path,
    );
    await isar.writeTxn(() async {});
    LocalSystemHlc.initializeSync(isar, 1);
  });

  tearDown(() async {
    await isar.close();
  });
  test('Merge newer primitive field', () async {
    final a = SomeOtherTestClass(1);
    final b = SomeOtherTestClass(2);
    await isar.writeTxn(() async {
      await isar.someOtherTestClass.put(a);
      await isar.someOtherTestClass.put(b);
    });

    expect(a.c, isNot(equals(b.c)));
    expect(a.c_fieldHlc.hybridTime, lessThan(b.c_fieldHlc.hybridTime));
    expect(
      a.SomeOtherTestClass_classHlc.hybridTime,
      lessThan(b.SomeOtherTestClass_classHlc.hybridTime),
    );

    a.merge(b);

    expect(a.c, equals(b.c));
    expect(a.c_fieldHlc, equals(b.c_fieldHlc));
    expect(
      a.SomeOtherTestClass_classHlc,
      equals(b.SomeOtherTestClass_classHlc),
    );
  });

  test('Merge older primitive field', () async {
    final a = SomeOtherTestClass(1);
    final b = SomeOtherTestClass(2);
    const c = 3;
    await isar.writeTxn(() async {
      await isar.someOtherTestClass.put(a);
      await isar.someOtherTestClass.put(b);
      a.c = c;
      await isar.someOtherTestClass.put(a);
    });

    expect(a.c, isNot(equals(b.c)));
    expect(a.c_fieldHlc.hybridTime, greaterThan(b.c_fieldHlc.hybridTime));
    expect(
      a.SomeOtherTestClass_classHlc.hybridTime,
      greaterThan(b.SomeOtherTestClass_classHlc.hybridTime),
    );

    a.merge(b);

    expect(a.c, equals(c));
    expect(b.c, isNot(equals(c)));
    expect(a.c_fieldHlc, greaterThan(b.c_fieldHlc));
    expect(
      a.SomeOtherTestClass_classHlc,
      greaterThan(b.SomeOtherTestClass_classHlc),
    );
  });
}
