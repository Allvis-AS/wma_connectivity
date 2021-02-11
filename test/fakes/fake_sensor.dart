import 'package:rxdart/rxdart.dart';
import 'package:wma_connectivity/src/sensor.dart';
import 'package:wma_connectivity/src/sensor_event_type.dart';
import 'package:wma_connectivity/src/sensor_event.dart';

import 'fake_sensor_event_type.dart';

class FakeSensor implements Sensor {
  FakeSensor(this.threshold);

  final double threshold;
  final _events = PublishSubject<SensorEvent>();

  @override
  SensorEventType get type => FakeSensorEventType(threshold);

  @override
  Stream<SensorEvent> get events => _events;

  @override
  void dispose() {
    _events.close();
  }

  Future<void> add(bool reached, [DateTime? timestamp]) async {
    _events.add(SensorEvent(
      type: type,
      value: reached ? 1.0 : 0.0,
      timestamp: timestamp ?? DateTime.now(),
    ));
    await Future.delayed(const Duration(milliseconds: 1));
  }
}
