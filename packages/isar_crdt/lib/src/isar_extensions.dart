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

import 'hlc.dart';

Hlc updateHlc<T extends Comparable>(T? oldVal, T newVal, Hlc? oldHlc) {
  return oldHlc == null || oldVal != newVal
      ? Hlc.now().increaseClock()
      : oldHlc;
}
