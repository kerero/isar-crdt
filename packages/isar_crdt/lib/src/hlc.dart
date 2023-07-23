import "package:isar/isar.dart";
import 'dart:math';

part 'hlc.g.dart';

const _shift = 16;
const _maxCounter = 0xFFFF;
const _maxDrift = 60000; // 1 minute in ms

/// A Hybrid Logical Clock implementation.
/// This class trades time precision for a guaranteed monotonically increasing
/// clock in distributed systems.
/// Inspiration: https://cse.buffalo.edu/tech-reports/2014-04.pdf

// TODO: maybe it will be more wise to save only a int64 into isar.
@embedded
class Hlc implements Comparable<Hlc> {
  final int milliseconds;
  final int counter;
  late String? nodeId;
  static late final Hlc? _current;

  int get logicalTime => (milliseconds << _shift) + counter;

  Hlc.fromParameters(int milliseconds, this.counter, {this.nodeId})
      : assert(counter <= _maxCounter),
        // Detect microseconds and convert to milliseconds
        milliseconds = milliseconds < 0x0001000000000000
            ? milliseconds
            : milliseconds ~/ 1000 {
    if (nodeId == null || nodeId?.isEmpty == true) {
      this.nodeId = ""; // TODO: find a way to get unique node id
    }
  }
  Hlc() : this.zero();

  // TODO: define acceptable API and implement get next clock tick
  Hlc increaseClock() => this;

  Hlc.zero() : this.fromParameters(0, 0);

  Hlc.fromDate(
    DateTime dateTime,
  ) : this.fromParameters(dateTime.millisecondsSinceEpoch, 0);

  Hlc.now() : this.fromDate(DateTime.now());

  Hlc.fromLogicalTime(logicalTime, {String? nodeId})
      : this.fromParameters(logicalTime >> _shift, logicalTime & _maxCounter,
            nodeId: nodeId);

  factory Hlc.parse(String timestamp) {
    final counterDash = timestamp.indexOf('-', timestamp.lastIndexOf(':'));
    final nodeIdDash = timestamp.indexOf('-', counterDash + 1);
    final milliseconds = DateTime.parse(timestamp.substring(0, counterDash))
        .millisecondsSinceEpoch;
    final counter =
        int.parse(timestamp.substring(counterDash + 1, nodeIdDash), radix: 16);
    final nodeId = timestamp.substring(nodeIdDash + 1);
    return Hlc.fromParameters(milliseconds, counter, nodeId: nodeId);
  }

  Hlc apply({int? milliseconds, int? counter, String? nodeId}) =>
      Hlc.fromParameters(
          milliseconds ?? this.milliseconds, counter ?? this.counter,
          nodeId: nodeId ?? this.nodeId);

  /// Generates a unique, monotonic timestamp suitable for transmission to
  /// another system in string format. Local wall time will be used if
  /// [milliseconds] isn't supplied.
  factory Hlc.send(Hlc canonical, {int? milliseconds}) {
    // Retrieve the local wall time if milliseconds is null
    milliseconds = milliseconds ?? DateTime.now().millisecondsSinceEpoch;

    // Unpack the canonical time and counter
    final millisecondsOld = canonical.milliseconds;
    final counterOld = canonical.counter;

    // Calculate the next time and counter
    // * ensure that the logical time never goes backward
    // * increment the counter if time does not advance
    final millisecondsNew = max(millisecondsOld, milliseconds);
    final counterNew = millisecondsOld == millisecondsNew ? counterOld + 1 : 0;

    // Check the result for drift and counter overflow
    if (millisecondsNew - milliseconds > _maxDrift) {
      throw ClockDriftException(millisecondsNew, milliseconds);
    }
    if (counterNew > _maxCounter) {
      throw OverflowException(counterNew);
    }

    return Hlc.fromParameters(millisecondsNew, counterNew,
        nodeId: canonical.nodeId);
  }

  /// Compares and validates a timestamp from a remote system with the local
  /// canonical timestamp to preserve monotonicity.
  /// Returns an updated canonical timestamp instance.
  /// Local wall time will be used if [milliseconds] isn't supplied.
  factory Hlc.recv(Hlc canonical, Hlc remote, {int? milliseconds}) {
    // Retrieve the local wall time if milliseconds is null
    milliseconds = milliseconds ?? DateTime.now().millisecondsSinceEpoch;

    // No need to do any more work if the remote logical time is lower
    if (canonical.logicalTime >= remote.logicalTime) return canonical;

    // Assert the node id
    if (canonical.nodeId == remote.nodeId) {
      throw DuplicateNodeException(canonical.nodeId.toString());
    }
    // Assert the remote clock drift
    if (remote.milliseconds - milliseconds > _maxDrift) {
      throw ClockDriftException(remote.milliseconds, milliseconds);
    }

    return Hlc.fromLogicalTime(remote.logicalTime, nodeId: canonical.nodeId);
  }

  String toJson() => toString();

  @override
  String toString() =>
      '${DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true).toIso8601String()}'
      '-${counter.toRadixString(16).toUpperCase().padLeft(4, '0')}'
      '-$nodeId';

  @override
  int get hashCode => Object.hash(milliseconds, counter, nodeId).hashCode;

  @override
  bool operator ==(other) => other is Hlc && compareTo(other) == 0;

  bool operator <(other) => other is Hlc && compareTo(other) < 0;

  bool operator <=(other) => this < other || this == other;

  bool operator >(other) => other is Hlc && compareTo(other) > 0;

  bool operator >=(other) => this > other || this == other;

  @override
  int compareTo(Hlc other) {
    final time = logicalTime.compareTo(other.logicalTime);
    return time != 0 ? time : (nodeId as Comparable).compareTo(other.nodeId);
  }
}

class ClockDriftException implements Exception {
  final int drift;

  ClockDriftException(int millisecondsTs, int millisecondsWall)
      : drift = millisecondsTs - millisecondsWall;

  @override
  String toString() => 'Clock drift of $drift ms exceeds maximum ($_maxDrift)';
}

class OverflowException implements Exception {
  final int counter;

  OverflowException(this.counter);

  @override
  String toString() => 'Timestamp counter overflow: $counter';
}

class DuplicateNodeException implements Exception {
  final String nodeId;

  DuplicateNodeException(this.nodeId);

  @override
  String toString() => 'Duplicate node: $nodeId';
}
