import 'package:wma_connectivity/src/sensor_event_type.dart';

class DnsSensorEventType extends SensorEventType {
  const DnsSensorEventType() : super(global: false);

  @override
  String toString() => 'DnsSensorEventType';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DnsSensorEventType;
  }

  @override
  int get hashCode => 31;
}
