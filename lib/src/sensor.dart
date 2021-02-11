import 'package:meta/meta.dart';
import 'package:wma_connectivity/src/sensor_event.dart';
import 'package:wma_connectivity/src/sensor_event_type.dart';

abstract class Sensor {
  /// The type of sensor events this [Sensor] produces.
  SensorEventType get type;

  /// A sequence of events this [Sensor] has sensed.
  Stream<SensorEvent> get events;

  @mustCallSuper
  void dispose();
}
