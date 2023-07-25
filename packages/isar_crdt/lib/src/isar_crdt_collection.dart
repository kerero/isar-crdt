import '../isar_crdt.dart';
import 'package:isar/isar.dart';

class IsarCrdtCollection<OBJ extends IsarCrdtBase>
    extends IsarCollectionShell<OBJ> {
  IsarCrdtCollection(super.originalCollection);

  @override
  Future<Id> put(OBJ object) async {
    final id = schema.getId(object);
    final oldObj = await get(id);
    object.updateHLCs(oldObj, object);
    return super.put(object);
  }
}
