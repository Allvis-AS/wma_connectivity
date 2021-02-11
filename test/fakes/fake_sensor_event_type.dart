import 'package:wma_connectivity/wma_connectivity.dart';

import 'fake_connection.dart';

class FakeSensorEventType extends SensorEventType {
  const FakeSensorEventType(this.threshold) : super(global: false);

  final double threshold;

  @override
  Connection create(double metric) {
    return FakeConnection(metric >= threshold);
  }

  @override
  String toString() => 'FakeSensorEventType';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FakeSensorEventType;
  }

  @override
  int get hashCode => 31;
}
