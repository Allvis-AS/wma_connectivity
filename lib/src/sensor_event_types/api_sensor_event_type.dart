import 'package:wma_connectivity/src/sensor_event_type.dart';

class ApiSensorEventType extends SensorEventType {
  const ApiSensorEventType() : super(global: false);

  @override
  String toString() => 'ApiSensorEventType';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ApiSensorEventType;
  }
}
