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
    oldListHlc = oldListHlc.toList(); // Isar deserialize fixed size lists
    oldListHlc.removeRange(newList.length, oldList.length);
  } else if (oldList.length < newList.length) {
    oldListHlc = oldListHlc.toList(); // Isar deserialize fixed size lists
    oldListHlc.addAll(List<Hlc>.filled(
        newList.length - oldList.length, HybridLogicalClock.now()));
  }

  // For embedded lists
  if (T is IsarCrdtBase) {
    for (int i = 0; i < min(oldList.length, newList.length); i++) {
      Hlc objectHlc =
          (newList[i] as IsarCrdtBase<T>).updateHLCs(oldList[i], newList[i]);
      if (objectHlc > oldListHlc[i]) {
        updated = true;
        oldListHlc[i] = HybridLogicalClock.now();
      }
    }
  } else {
    // for primitive lists
    for (int i = 0; i < min(oldList.length, newList.length); i++) {
      if (oldList[i] != newList[i]) {
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
