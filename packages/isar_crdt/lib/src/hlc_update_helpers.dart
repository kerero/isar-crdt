import 'package:isar_crdt/src/hlc.dart';
import 'package:isar_crdt/src/isar_crdt_base_class.dart';


Hlc updatePrimitivesHlc<T>(T? oldVal, T newVal, Hlc? oldHlc) {
  return oldHlc == null || oldVal != newVal ? Hlc.now() : oldHlc;
}

// TODO: write tests for this
(Hlc, List<Hlc>) updateListHlc<T>(
    List<T>? oldList, List<T> newList, Hlc? oldHlc, List<Hlc>? oldListHlc) {
  var updated = false;
  oldHlc ??= Hlc.now();
  oldList ??= [];
  oldListHlc ??= [];

  if (oldList.length > newList.length) {
    for (var i = newList.length - 1; i < oldList.length; i++) {
      // Mark delete operations
      oldListHlc[i] = Hlc.now();
    }
    updated = true;
  } else if (oldList.length < newList.length) {
    // Make list growable (https://github.com/isar/isar/issues/703)
    oldListHlc = oldListHlc.toList()
      ..addAll(List<Hlc>.filled(newList.length - oldList.length, Hlc.now()));
    updated = true;
  }

  // For embedded lists
  if (newList.firstOrNull is IsarCrdtBase) {
    for (var i = 0; i < newList.length; i++) {
      final objectHlc = (newList[i] as IsarCrdtBase<T>)
          .updateHLCs(oldList.elementAtOrNull(i));
      if (objectHlc > oldListHlc[i]) {
        updated = true;
        oldListHlc[i] = objectHlc;
      }
    }
  } else {
    // for primitive lists
    for (var i = 0; i < newList.length; i++) {
      if (oldList.elementAtOrNull(i) != newList[i]) {
        updated = true;
        oldListHlc[i] = Hlc.now();
      }
    }
  }

  return (
    updated || newList.length != oldList.length ? Hlc.now() : oldHlc,
    oldListHlc
  );
}
