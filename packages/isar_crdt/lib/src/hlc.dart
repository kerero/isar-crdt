import 'package:isar/isar.dart';
import 'package:quiver/core.dart';

part 'hlc.g.dart';

const _logicalTimeSize = 16;
const _maxLogicalTime = ~(-1 << _logicalTimeSize);
const _maxDrift = 60000; // 1 minute in ms

/// A Hybrid Logical Clock implementation.
/// This class trades time precision for a guaranteed monotonically increasing
/// clock in distributed systems.
/// Inspiration: https://cse.buffalo.edu/tech-reports/2014-04.pdf

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
        DateTime.now().millisecondsSinceEpoch << _logicalTimeSize;
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

@embedded
class Hlc implements Comparable<Hlc> {
  final int hybridTime;
  final int nodeId;
  // TODO: just make it nullable?
  static const int nullNodeId = -1;

  Hlc({this.hybridTime = 0, this.nodeId = Hlc.nullNodeId});

  Hlc.fromPhysicalTime(int physicalTime, {int? nodeId, int logicalTime = 0})
      : assert(logicalTime <= _maxLogicalTime),
        nodeId = nodeId ?? LocalSystemHlc._localSystemClock!.nodeId,
        hybridTime = physicalTime << _logicalTimeSize + logicalTime;
  Hlc.zero({int nodeId = nullNodeId}) : this(hybridTime: 0, nodeId: nodeId);
  Hlc.now()
      : this(
            hybridTime: LocalSystemHlc._localSystemClock!.hybridTime,
            nodeId: LocalSystemHlc._localSystemClock!.nodeId);

  @override
  bool operator ==(other) => other is Hlc && compareTo(other) == 0;

  bool operator <(Hlc other) => compareTo(other) < 0;

  bool operator <=(Hlc other) => this < other || this == other;

  bool operator >(Hlc other) => compareTo(other) > 0;

  bool operator >=(Hlc other) => this > other || this == other;

  @override
  int compareTo(Hlc other) {
    final t = hybridTime.compareTo(other.hybridTime);
    return t != 0 ? t : nodeId.compareTo(other.nodeId);
  }

  @override
  int get hashCode => hash2(hybridTime, nodeId);
}

class HlcDriftException implements Exception {
  final int drift;

  HlcDriftException(int millisecondsTs, int millisecondsWall)
      : drift = millisecondsTs - millisecondsWall;

  @override
  String toString() => 'Clock drift of $drift ms exceeds maximum ($_maxDrift)';
}

class LogicalTimeOverflowException implements Exception {
  final int counter;

  LogicalTimeOverflowException(this.counter);

  @override
  String toString() => 'Timestamp counter overflow: $counter';
}

class DuplicateNodeIdException implements Exception {
  final String nodeId;

  DuplicateNodeIdException(this.nodeId);

  @override
  String toString() => 'Duplicate node: $nodeId';
}

class LocalSystemHlcUninitializedException implements Exception {
  LocalSystemHlcUninitializedException();

  @override
  String toString() =>
      'LocalSystemHlc is uninitialized. Please use initialize() or initializeSync()';
}

class LocalSystemHlcException implements Exception {
  String msg;
  LocalSystemHlcException(this.msg);

  @override
  String toString() => msg;
}
