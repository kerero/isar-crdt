// import 'package:isar/isar.dart';

// extension ISarCollectionCrdtSupport<String> on IsarCollection<String> {
//   void updateHLCs(Id id, ) async {
//     final oldObj = await get(id);
//   }
//   // void get(int id){

//   // }
// }

//   typedef UpdateHLCs<T> = void Function(
//   T object,
//   IsarWriter writer,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// );
// extension ISarSchemaCrdtSupport<T> on CollectionSchema{
//   UpdateHLCs<T>? updateHLCs;
// }

import 'dart:math';

import 'hlc.dart';

Hlc updateHlcPrimitives<T>(T? oldVal, T newVal, Hlc? oldHlc) {
  return oldHlc == null || oldVal != newVal
      ? Hlc.now().increaseClock()
      : oldHlc;
}

// TODO: write tests for this
Hlc updatePrimitiveListHlc<T>(
    List<T>? oldList, List<T> newList, Hlc? oldHlc, List<Hlc>? oldListHlc) {
  var updated = false;
  oldHlc ??= Hlc.now();
  oldList ??= [];
  oldListHlc ??= List.filled(newList.length, Hlc.zero());

  if (oldList.length > newList.length) {
    oldListHlc.removeRange(newList.length, oldList.length);
  } else if (oldList.length < newList.length) {
    oldListHlc
        .addAll(List<Hlc>.filled(newList.length - oldList.length, Hlc.now()));
  }

  for (int i = 0; i < min(oldList.length, newList.length); i++) {
    if (oldList[i] != newList[i]) {
      updated = true;
      oldListHlc[i] = Hlc.now();
    }
  }

  return updated || newList.length != oldList.length ? Hlc.now() : oldHlc;
}
