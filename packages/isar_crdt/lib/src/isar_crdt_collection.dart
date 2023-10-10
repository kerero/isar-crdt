import '../isar_crdt.dart';
import 'package:isar/isar.dart';

class IsarCrdtCollection<OBJ extends IsarCrdtBase>
    extends IsarCollectionShell<OBJ> {
  IsarCrdtCollection(super.originalCollection);

  @override
  Future<Id> put(OBJ object) async {
    var id = schema.getId(object);
    LocalSystemHlc.incrementLocalTime();
    OBJ? oldObj;

    // Ids need to be unique across nodes
    if (id == Isar.autoIncrement) {
      // TODO: after Isar 4 release switch to IsarCollection.autoIncrement() + localNodeId
      id = LocalSystemHlc.localSystemClock.hashCode;
      schema.attach(this, id, object);
    } else {
      oldObj = await get(id);
    }

    object.updateHLCs(oldObj);
    return super.put(object);
  }
}
