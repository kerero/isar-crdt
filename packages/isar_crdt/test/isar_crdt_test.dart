import 'package:isar_crdt/isar_crdt.dart';
import 'package:test/test.dart';
import 'package:isar/isar.dart';
import 'dart:io';

void main() {
  late Isar isar;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open([LocalSystemHlcStoreSchema],
        directory: Directory.systemTemp.path);
    await isar.writeTxn(() async {});
    LocalSystemHlc.initializeSync(isar, 1);
  });

  tearDown(() async {
    await isar.close();
  });

  test('Update val', () async {
    const oldVal = 1;
    const newVal = 2;
    await isar.writeTxn(() async {
      Hlc oldHlc = Hlc.now();
      await LocalSystemHlc.incrementLocalTime();
      Hlc newHlc = Hlc.now();
      expect(newHlc, greaterThan(oldHlc));
      var resHlc = updatePrimitivesHlc(oldVal, newVal, oldHlc);
      expect(resHlc, equals(newHlc));
    });
  });

  test('new val', () async {
    const oldVal = 1;
    const newVal = 2;
    Hlc? oldHlc;
    await isar.writeTxn(() async {
      await LocalSystemHlc.incrementLocalTime();
      Hlc newHlc = Hlc.now();
      var resHlc = updatePrimitivesHlc(oldVal, newVal, oldHlc);
      expect(resHlc, equals(newHlc));
    });
  });

  test('Update same val', () async {
    const oldVal = 1;
    const newVal = oldVal;
    await isar.writeTxn(() async {
      Hlc oldHlc = Hlc.now();
      await LocalSystemHlc.incrementLocalTime();
      var newHlc = Hlc.now();
      var resHlc = updatePrimitivesHlc(oldVal, newVal, oldHlc);
      expect(resHlc, equals(oldHlc));
      expect(oldHlc, isNot(equals(newHlc)));
      expect(oldHlc.hybridTime, lessThan(newHlc.hybridTime));
    });
  });
}
