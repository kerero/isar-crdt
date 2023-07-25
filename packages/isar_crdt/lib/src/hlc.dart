const _shift = 16;
const _maxCounter = 0xFFFF;
const _maxDrift = 60000; // 1 minute in ms

/// A Hybrid Logical Clock implementation.
/// This class trades time precision for a guaranteed monotonically increasing
/// clock in distributed systems.
/// Inspiration: https://cse.buffalo.edu/tech-reports/2014-04.pdf

typedef Hlc = int;

// TODO: this is a stub for testing and not functional
abstract final class HybridLogicalClock {
  static int zero() => 0;

  static int now() => DateTime.now().millisecondsSinceEpoch;
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
