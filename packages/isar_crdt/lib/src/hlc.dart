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

@Collection(accessor: '_localSystemHlc')
class LocalSystemHlc {
  static const int collectionItemId = 1;
  Id id = collectionItemId;
  Hlc? instanceHlc;
  static Hlc? hlc;

  LocalSystemHlc(this.instanceHlc);

  static void requireInitialization() {
    if (hlc == null) {
      throw LocalSystemHlcUninitializedException();
    }
  }

  static Hlc incrementLocalTime() {
    requireInitialization();
    final physicalTime =
        DateTime.now().millisecondsSinceEpoch << _logicalTimeSize;
    hlc = Hlc(
        hybridTime:
            physicalTime > hlc!.hybridTime ? physicalTime : hlc!.hybridTime + 1,
        nodeId: hlc!.nodeId);
    return hlc!;
  }

  static Future initialize(Isar isar, Future<int> Function() getLocalNodeId,
      {Future<int> Function()? getLocalHybridTime}) async {
    final restoredHlc =
        (await isar._localSystemHlc.get(collectionItemId))?.instanceHlc;

    // Check if the previous local system Hlc was saved
    if (restoredHlc != null) {
      hlc = restoredHlc;
    } else {
      // Initialize new clock
      hlc = Hlc(
          hybridTime: (await getLocalHybridTime?.call()) ??
              Hlc.fromPhysicalTime(DateTime.now().millisecondsSinceEpoch)
                  .hybridTime,
          nodeId: await getLocalNodeId());
      await isar.writeTxn(() => isar._localSystemHlc.put(LocalSystemHlc(hlc)));
    }
  }

  static void initializeSync(Isar isar, int Function() getLocalNodeId,
      {int Function()? getLocalHybridTime}) {
    final restoredHlc =
        (isar._localSystemHlc.getSync(collectionItemId))?.instanceHlc;

    // Check if the previous local system Hlc was saved
    if (restoredHlc != null) {
      hlc = restoredHlc;
    } else {
      // Initialize new clock
      hlc = Hlc(
          hybridTime: (getLocalHybridTime?.call()) ??
              Hlc.fromPhysicalTime(DateTime.now().millisecondsSinceEpoch)
                  .hybridTime,
          nodeId: getLocalNodeId());
      isar.writeTxnSync(
          () => isar._localSystemHlc.putSync(LocalSystemHlc(hlc)));
    }
  }
}

@embedded
class Hlc implements Comparable<Hlc> {
  final int hybridTime;
  final int nodeId;
  static const int nullNodeId = -1;

  Hlc({this.hybridTime = 0, this.nodeId = Hlc.nullNodeId});

  Hlc.fromPhysicalTime(int physicalTime, {int? nodeId, int logicalTime = 0})
      : assert(logicalTime <= _maxLogicalTime),
        nodeId = nodeId ?? LocalSystemHlc.hlc!.nodeId,
        hybridTime = physicalTime << _logicalTimeSize + logicalTime;
  Hlc.zero({int nodeId = nullNodeId}) : this(hybridTime: 0, nodeId: nodeId);
  Hlc.now()
      : this(
            hybridTime: LocalSystemHlc.hlc!.hybridTime,
            nodeId: LocalSystemHlc.hlc!.nodeId);

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
