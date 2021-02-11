import 'package:flutter/foundation.dart';
import 'package:wma_connectivity/src/connection.dart';

abstract class SensorEventType {
  const SensorEventType({
    required this.global,
  });

  /// Whether this event type should affect other connection specific
  /// event types.
  ///
  /// Typically event types like [SocketException] should be global as they
  /// most likely affect all connections.
  final bool global;

  /// Creates the appropriate [Connection] for this [SensorEventType] based on
  /// the calculated [metric] (usually with a threshold).
  ///
  /// Subclasses with [global] set to [false] *must* implement [create()].
  Connection create(double metric) {
    assert(!global,
        '${objectRuntimeType(this, '<optimized-out>')} must implement createConnection.');
    throw UnimplementedError('This sensor event type does not support ');
  }
}
