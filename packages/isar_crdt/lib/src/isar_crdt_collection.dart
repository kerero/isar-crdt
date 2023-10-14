import 'package:isar/isar.dart';
import 'package:isar_crdt/isar_crdt.dart';

class IsarCrdtCollection<OBJ extends IsarCrdtBase<OBJ>>
    extends IsarCollectionShell<OBJ> {
  IsarCrdtCollection(super.originalCollection);

  @override
  Future<Id> put(OBJ object) async {
    await _updateHlcs(object);
    return super.put(object);
  }

  @override
  Future<List<Id>> putAll(List<OBJ> objects) async {
    for (final obj in objects) {
      await _updateHlcs(obj);
    }
    return super.putAll(objects);
  }

  Future<void> _updateHlcs(OBJ object) async {
    var id = schema.getId(object);
    await LocalSystemHlc.incrementLocalTime();
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
  }
}
