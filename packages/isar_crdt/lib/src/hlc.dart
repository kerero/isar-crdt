import 'package:isar/isar.dart';
import 'package:quiver/core.dart';
import 'local_system_hlc.dart';

part 'hlc.g.dart';

/// A Hybrid Logical Clock implementation.
/// This class trades time precision for a guaranteed monotonically increasing
/// clock in distributed systems.
/// Inspiration: https://cse.buffalo.edu/tech-reports/2014-04.pdf

@embedded
class Hlc implements Comparable<Hlc> {
  static const logicalTimeSize = 16;
  static const maxLogicalTime = ~(-1 << logicalTimeSize);
  static const maxDrift = 60000; // 1 minute in ms

  final int hybridTime;
  final int nodeId;
  // TODO: just make it nullable?
  static const int nullNodeId = -1;

  Hlc({this.hybridTime = 0, this.nodeId = Hlc.nullNodeId});

  Hlc.fromPhysicalTime(int physicalTime, {int? nodeId, int logicalTime = 0})
      : assert(logicalTime <= logicalTimeSize),
        nodeId = nodeId ?? LocalSystemHlc.localSystemClock!.nodeId,
        hybridTime = physicalTime << logicalTimeSize + logicalTime;
  Hlc.zero({int nodeId = nullNodeId}) : this(hybridTime: 0, nodeId: nodeId);
  Hlc.now()
      : this(
            hybridTime: LocalSystemHlc.localSystemClock!.hybridTime,
            nodeId: LocalSystemHlc.localSystemClock!.nodeId);

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
  String toString() =>
      'Clock drift of $drift ms exceeds maximum (${Hlc.maxDrift})';
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
