import 'package:isar_crdt/isar_crdt.dart';

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
    oldListHlc = oldListHlc.toList();
    oldListHlc
        .addAll(List<Hlc>.filled(newList.length - oldList.length, Hlc.now()));
    updated = true;
  }

  // For embedded lists
  if (newList.firstOrNull is IsarCrdtBase) {
    for (int i = 0; i < newList.length; i++) {
      Hlc objectHlc = (newList[i] as IsarCrdtBase<T>)
          .updateHLCs(oldList.elementAtOrNull(i));
      if (objectHlc > oldListHlc[i]) {
        updated = true;
        oldListHlc[i] = objectHlc;
      }
    }
  } else {
    // for primitive lists
    for (int i = 0; i < newList.length; i++) {
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

// List<Hlc> mergeLists<T>(List<T> localList, List<T> remoteList,
//     List<Hlc> localListHlc, List<Hlc> remoteListHlc) {
//   if (localList.length > remoteList.length) {
//     var indicesToRemove = [];
//     for (var i = remoteList.length - 1; i < localList.length; i++) {
//       if (remoteListHlc.length > i && remoteListHlc[i] > localListHlc[i]) {
//         indicesToRemove.add(i);
//       }
//     }
//     for (var i in indicesToRemove.reversed) {
//       localList.removeAt(i);
//     }
//   } else if (localList.length < remoteList.length) {
//     for (var i = localList.length - 1; i < remoteList.length; i++) {
//       if (localListHlc.length <= i && localListHlc[i] < remoteListHlc[i]) {
//         localList.add(remoteList[i]);
//       }
//     }
//   }

//   // For embedded lists
//   if (remoteList.firstOrNull is IsarCrdtBase) {
//     for (int i = 0; i < remoteList.length; i++) {
//       Hlc objectHlc = (newList[i] as IsarCrdtBase<T>)
//           .updateHLCs(oldList.elementAtOrNull(i));
//       if (objectHlc > oldListHlc[i]) {
//         updated = true;
//         oldListHlc[i] = objectHlc;
//       }
//     }
//   } else {
//     // for primitive lists
//     for (int i = 0; i < newList.length; i++) {
//       if (oldList.elementAtOrNull(i) != newList[i]) {
//         updated = true;
//         oldListHlc[i] = Hlc.now();
//       }
//     }
//   }
// }
