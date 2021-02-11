import 'package:wma_connectivity/src/connections/dns_connection.dart';
import 'package:wma_connectivity/src/sensor_event_type.dart';

class DnsSensorEventType extends SensorEventType {
  const DnsSensorEventType({
    required this.threshold,
  }) : super(global: false);

  final double threshold;

  @override
  DnsConnection create(double metric) {
    return DnsConnection(metric >= threshold);
  }

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
