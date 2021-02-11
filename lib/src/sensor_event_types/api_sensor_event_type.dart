import 'package:wma_connectivity/src/connections/api_connection.dart';
import 'package:wma_connectivity/src/sensor_event_type.dart';

class ApiSensorEventType extends SensorEventType {
  const ApiSensorEventType({
    required this.threshold,
  }) : super(global: false);

  final double threshold;

  @override
  ApiConnection create(double metric) {
    return ApiConnection(metric >= threshold);
  }

  @override
  String toString() => 'ApiSensorEventType';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ApiSensorEventType;
  }

  @override
  int get hashCode => 31;
}
