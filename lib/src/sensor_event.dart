import 'package:wma_connectivity/src/sensor_event_type.dart';
import 'package:wma_connectivity/src/sensor_event_types/api_sensor_event_type.dart';
import 'package:wma_connectivity/src/sensor_event_types/dns_sensor_event_type.dart';
import 'package:wma_connectivity/src/sensor_event_types/socket_exception_sensor_event_type.dart';

class SensorEvent {
  const SensorEvent({
    required this.type,
    required this.value,
    required this.timestamp,
  });

  /// The type of sensor this event originates from.
  final SensorEventType type;

  /// A connectivity metric in the range `0.0 ≤ value ≤ 1.0`.
  ///
  /// Used for calculating the weighted moving average.
  final double value;

  /// The time this event occured.
  final DateTime timestamp;

  /// Constructs an event for an API sensor.
  factory SensorEvent.api(bool reached, double threshold,
          [DateTime? timestamp]) =>
      SensorEvent(
        type: ApiSensorEventType(threshold: threshold),
        value: reached ? 1.0 : 0.0,
        timestamp: timestamp ?? DateTime.now(),
      );

  /// Constructs an event for a DNS sensor.
  factory SensorEvent.dns(bool reached, double threshold,
          [DateTime? timestamp]) =>
      SensorEvent(
        type: DnsSensorEventType(threshold: threshold),
        value: reached ? 1.0 : 0.0,
        timestamp: timestamp ?? DateTime.now(),
      );

  /// Constructs an event for a [SocketException] sensor.
  factory SensorEvent.socketException([DateTime? timestamp]) => SensorEvent(
        type: const SocketExceptionSensorEventType(),
        value: 0.0,
        timestamp: timestamp ?? DateTime.now(),
      );

  @override
  String toString() =>
      'SensorEvent(type: $type, value: $value, timestamp: $timestamp)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SensorEvent &&
        o.type == type &&
        o.value == value &&
        o.timestamp == timestamp;
  }

  @override
  int get hashCode => type.hashCode ^ value.hashCode ^ timestamp.hashCode;
}
