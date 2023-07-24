import 'dart:math';
import 'package:isar_crdt/isar_crdt.dart';

Hlc updatePrimitivesHlc<T>(T? oldVal, T newVal, Hlc? oldHlc) {
  return oldHlc == null || oldVal != newVal
      ? Hlc.now().increaseClock()
      : oldHlc;
}

// TODO: write tests for this
Hlc updateListHlc<T>(
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

  // For embedded lists
  if (T is IsarCrdtBase) {
    for (int i = 0; i < min(oldList.length, newList.length); i++) {
      Hlc objectHlc = (newList[i] as dynamic).updateHLCs(oldList[i]);
      if (objectHlc > oldListHlc[i]) {
        updated = true;
        oldListHlc[i] = Hlc.now();
      }
    }
  } else {
    // for primitive lists
    for (int i = 0; i < min(oldList.length, newList.length); i++) {
      if (oldList[i] != newList[i]) {
        updated = true;
        oldListHlc[i] = Hlc.now();
      }
    }
  }

  return updated || newList.length != oldList.length ? Hlc.now() : oldHlc;
}
