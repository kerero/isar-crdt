import 'dart:math';
import 'package:isar_crdt/isar_crdt.dart';

Hlc updatePrimitivesHlc<T>(T? oldVal, T newVal, Hlc? oldHlc) {
  return oldHlc == null || oldVal != newVal ? HybridLogicalClock.now() : oldHlc;
}

// TODO: write tests for this
(Hlc, List<Hlc>) updateListHlc<T>(
    List<T>? oldList, List<T> newList, Hlc? oldHlc, List<Hlc>? oldListHlc) {
  var updated = false;
  oldHlc ??= HybridLogicalClock.now();
  oldList ??= List.empty(growable: true);
  oldListHlc ??= [];

  if (oldList.length > newList.length) {
    // Make list growable (https://github.com/isar/isar/issues/703)
    oldListHlc = oldListHlc.toList();
    oldListHlc.removeRange(newList.length, oldList.length);
    updated = true;
  } else if (oldList.length < newList.length) {
    // Make list growable (https://github.com/isar/isar/issues/703)
    oldListHlc = oldListHlc.toList();
    oldListHlc.addAll(List<Hlc>.filled(
        newList.length - oldList.length, HybridLogicalClock.now()));
    updated = true;
  }

  // For embedded lists
  if (newList.firstOrNull is IsarCrdtBase) {
    for (int i = 0; i < oldListHlc.length; i++) {
      Hlc objectHlc = (newList[i] as IsarCrdtBase<T>)
          .updateHLCs(oldList.elementAtOrNull(i));
      if (objectHlc > oldListHlc[i]) {
        updated = true;
        oldListHlc[i] = objectHlc;
      }
    }
  } else {
    // for primitive lists
    for (int i = 0; i < oldListHlc.length; i++) {
      if (oldList.elementAtOrNull(i) != newList[i]) {
        updated = true;
        oldListHlc[i] = HybridLogicalClock.now();
      }
    }
  }

  return (
    updated || newList.length != oldList.length
        ? HybridLogicalClock.now()
        : oldHlc,
    oldListHlc
  );
}
