import 'dart:io';

import 'package:isar/isar.dart';
import 'package:isar_crdt/isar_crdt.dart';
import 'package:test/test.dart';

part 'merge_embedded_test.isar.g.dart';
part 'merge_embedded_test.isar_crdt.g.dart';

@collection
@crdtCollection
class SomeClass extends _SomeClassCrdt {
  SomeClass(this.i, this.j, this.d, this.e);
  Id id = Isar.autoIncrement;
  int i;
  int j;
  double d;
  SomeEmbeddedClass e;
}

@embedded
@crdtEmbedded
class SomeEmbeddedClass extends _SomeEmbeddedClassCrdt {
  SomeEmbeddedClass({this.f = 0, this.s = ''});
  float f;
  String s;
}

void main() {
  late Isar isar;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open(
      [LocalSystemHlcStoreSchema, SomeClassSchema],
      directory: Directory.systemTemp.path,
    );
    await isar.writeTxn(() async {});
    LocalSystemHlc.initializeSync(isar, 1);
  });

  tearDown(() async {
    await isar.close();
  });

  test('Merge embedded', () async {
    final a = SomeClass(0, 0, 0, SomeEmbeddedClass(s: '0'));
    final b = SomeClass(0, 0, 0, SomeEmbeddedClass(s: '0'));
    final hlcs = <Hlc>[]..add(LocalSystemHlc.localSystemClock);
    await isar.writeTxn(() async {
      await isar.someClass.putAll([a, b]);
      hlcs.add(LocalSystemHlc.localSystemClock);
      a
        ..i = 1
        ..e.f = 1;
      b
        ..d = 2
        ..e.s = '2'
        ..e.f = 2;
      await isar.someClass.put(a);
      hlcs.add(LocalSystemHlc.localSystemClock);
      await isar.someClass.put(b);
      hlcs.add(LocalSystemHlc.localSystemClock);
    });

    expect(hlcs[0], lessThan(hlcs[1]));
    expect(hlcs[2], lessThan(hlcs[3]));
    expect(hlcs[1], lessThan(hlcs[2]));

    a.merge(b);
    b.merge(a);

    void checkValues(SomeClass c) {
      expect(c.i, equals(1));
      expect(c.i_fieldHlc, hlcs[2]);

      expect(c.j, equals(0));
      expect(c.j_fieldHlc, hlcs[1]);

      expect(c.d, equals(2));
      expect(c.d_fieldHlc, hlcs[3]);

      expect(c.e.f, equals(2));
      expect(c.e.f_fieldHlc, hlcs[3]);

      expect(c.e.s, equals('2'));
      expect(c.e.s_fieldHlc, hlcs[3]);
    }

    checkValues(a);
    checkValues(b);
  });
}
