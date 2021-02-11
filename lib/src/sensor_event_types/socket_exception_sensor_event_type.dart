import 'package:wma_connectivity/src/sensor_event_type.dart';

class SocketExceptionSensorEventType extends SensorEventType {
  const SocketExceptionSensorEventType() : super(global: true);

  @override
  String toString() => 'SocketExceptionSensorEventType';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SocketExceptionSensorEventType;
  }
}
