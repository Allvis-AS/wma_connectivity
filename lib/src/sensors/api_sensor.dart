import 'dart:io';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wma_connectivity/src/sensor.dart';
import 'package:wma_connectivity/src/sensor_event.dart';
import 'package:wma_connectivity/src/sensor_event_types/api_sensor_event_type.dart';

class ApiSensor implements Sensor {
  ApiSensor({
    required this.uri,
    double threshold = 0.5,
    Duration interval = const Duration(seconds: 10),
    Duration timeout = const Duration(seconds: 10),
  }) : type = ApiSensorEventType(threshold: threshold) {
    _events = Stream.periodic(interval, (i) => i)
        .exhaustMap((_) => Stream.fromFuture(_check(timeout))
            .timeout(timeout)
            .map((success) => SensorEvent.api(success, threshold))
            .onErrorReturn(SensorEvent.api(false, threshold)))
        .takeUntil(_destroy)
        .publishReplay(maxSize: 1)
        .autoConnect();
  }

  /// The URI to make a request to, expecting a `200` response code.
  ///
  /// This should be an anonymous endpoint in your API,
  /// i.e. `https://api.contoso.com/ping` with a successful response (it does
  /// not have to be empty).
  final Uri uri;

  final _destroy = PublishSubject<void>();
  late final Stream<SensorEvent> _events;

  @override
  final ApiSensorEventType type;

  @override
  Stream<SensorEvent> get events => _events;

  @override
  @mustCallSuper
  void dispose() {
    _destroy.add(null);
    _destroy.close();
  }

  Future<bool> _check(Duration timeout) async {
    final client = HttpClient();
    try {
      client.connectionTimeout = timeout;
      final request = await HttpClient().getUrl(uri);
      final response = await request.close();
      return response.statusCode == 200;
    } finally {
      client.close();
    }
  }
}
