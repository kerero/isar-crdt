import 'hlc.dart';
import 'package:isar/isar.dart';

part 'local_system_hlc.g.dart';

@Collection(accessor: '_localSystemHlcStore')
class LocalSystemHlcStore {
  static const int collectionItemId = 1;
  Id id = collectionItemId;
  Hlc? storedHlc;
  LocalSystemHlcStore(this.storedHlc);
}

abstract final class LocalSystemHlc {
  static Hlc? _localSystemClock;
  static Isar? _isarInstance;
  static Hlc? get localSystemClock => _localSystemClock;

  static void requireInitialization() {
    if (_isarInstance == null) {
      throw LocalSystemHlcUninitializedException();
    }

    if (!_isarInstance!.isOpen) {
      throw LocalSystemHlcException("Isar instance is closed");
    }
  }

  static Future<Hlc> incrementLocalTime() async {
    requireInitialization();
    // TODO: check we have write txn aquired
    final physicalTime =
        DateTime.now().millisecondsSinceEpoch << Hlc.logicalTimeSize;
    var incremented = Hlc(
        hybridTime: physicalTime > _localSystemClock!.hybridTime
            ? physicalTime
            : _localSystemClock!.hybridTime + 1,
        nodeId: _localSystemClock!.nodeId);
    await _setClockNonTxn(incremented);
    return _localSystemClock!;
  }

  static Future<void> initialize(Isar isar, int localNodeId,
      {Hlc? defaultHlc}) async {
    LocalSystemHlc._isarInstance = isar;
    final restoredHlc = (await isar._localSystemHlcStore
            .get(LocalSystemHlcStore.collectionItemId))
        ?.storedHlc;

    // Check if the previous local system Hlc was saved
    if (restoredHlc != null) {
      _localSystemClock = restoredHlc;
    } else {
      // Initialize new clock
      var newHlc = defaultHlc ??
          Hlc.fromPhysicalTime(DateTime.now().millisecondsSinceEpoch,
              nodeId: localNodeId);
      await _setClock(newHlc);
    }
  }

  static void initializeSync(Isar? isar, int localNodeId, {Hlc? defaultHlc}) {
    LocalSystemHlc._isarInstance = isar;
    final restoredHlc = (isar?._localSystemHlcStore
            .getSync(LocalSystemHlcStore.collectionItemId))
        ?.storedHlc;

    // Check if the previous local system Hlc was saved
    if (restoredHlc != null) {
      _localSystemClock = restoredHlc;
    } else {
      // Initialize new clock
      var newHlc = defaultHlc ??
          Hlc.fromPhysicalTime(DateTime.now().millisecondsSinceEpoch,
              nodeId: localNodeId);
      _setClockSync(newHlc);
    }
  }

  static Future<void> _setClock(Hlc newHlc) {
    requireInitialization();
    return _isarInstance!.writeTxn(() async {
      await _setClockNonTxn(newHlc);
    });
  }

  static Future<void> _setClockNonTxn(Hlc newHlc) async {
    requireInitialization();
    await _isarInstance!._localSystemHlcStore.put(LocalSystemHlcStore(newHlc));
    _localSystemClock = newHlc;
  }

  static void _setClockSync(Hlc newHlc) {
    requireInitialization();
    return _isarInstance!.writeTxnSync(() {
      _isarInstance!._localSystemHlcStore.putSync(LocalSystemHlcStore(newHlc));
      _localSystemClock = newHlc;
    });
  }

  static Future<void> overrideClock(Hlc hlc) {
    return _setClock(hlc);
  }

  static void overrideClockSync(Hlc hlc) {
    _setClockSync(hlc);
  }
}
