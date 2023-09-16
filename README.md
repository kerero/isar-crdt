<p align="center">
  <a href="https://isar.dev">
    <img src="https://raw.githubusercontent.com/isar/isar/main/.github/assets/isar.svg?sanitize=true" height="128">
  </a>
  <h1 align="center">Isar CRDT</h1>
</p>

# ⚠️ WIP ⚠️
This project aims to extend the functionality of the [Isar database](https://isar.dev/) to allow remote synchronization (isar/isar#2).

The remote synchronization is achieved by generating HLC ([Hybrid Logical Clock](https://martinfowler.com/articles/patterns-of-distributed-systems/hybrid-clock.html)) per field that act as a version number for the current value. This allows two versions of an object to be merged consistently while also retaining the newer version of each field.

## Usage
Add the `crdtCollection` annotation.
Use Isar interface normally.
```dart
import 'package:isar_crdt/isar_crdt.dart'; //  <-- 
import 'package:isar/isar.dart';

part 'test_class.isar_crdt.g.dart'; //  <-- 
part 'test_class.isar.g.dart'; // <-- instead of test_class.g.dart

@crdtCollection //  <-- 
@collection
class TestClass extends _TestClassCrdt {
    ...
}

...

// Create/update object
await isar.writeTxn(() {
    return isar.testClass.put(obj);
});

// Merge object from a remote node
await isar.writeTxn(() {
    return isar.testClass.merge(obj);
});
```

`isar.testClass` return `IsarCrdtCollection` (instead of `IsarCollection`) that abstract all the HLC handling logic.

## Limitations
to generate globally unique IDs for isar objects the following limitations are recommended to avoid ID collisions.
1. `4,294,967,295` objects per Isar collection.
2. `4,294,967,295` nodes or users.
