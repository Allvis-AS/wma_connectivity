import 'dart:io';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wma_connectivity/src/sensor.dart';
import 'package:wma_connectivity/src/sensor_event.dart';
import 'package:wma_connectivity/src/sensor_event_types/dns_sensor_event_type.dart';

class DnsSensor implements Sensor {
  DnsSensor({
    this.hosts = const [
      'cloudflare.com',
      'google.com',
      'microsoft.com',
    ],
    double threshold = 0.5,
    Duration interval = const Duration(seconds: 10),
    Duration timeout = const Duration(seconds: 10),
  }) : type = DnsSensorEventType(threshold: threshold) {
    _events = Stream.periodic(interval, (i) => i)
        .exhaustMap((_) => Rx.merge(hosts.map((h) =>
                Stream.fromFuture(InternetAddress.lookup(h))
                    .mapTo(SensorEvent.dns(true, threshold))
                    .onErrorResume((e) => Stream.empty())))
            .take(1)
            .defaultIfEmpty(SensorEvent.dns(false, threshold))
            .timeout(timeout)
            .onErrorReturn(SensorEvent.dns(false, threshold)))
        .takeUntil(_destroy)
        .publishReplay(maxSize: 1)
        .autoConnect();
  }

  /// The hosts to lookup in DNS.
  ///
  /// These should be highly-available hosts that are almost never down.
  /// The kind of hosts that, if they're unavailable, the entire internet is
  /// practically dead.
  final List<String> hosts;

  final _destroy = PublishSubject<void>();
  late final Stream<SensorEvent> _events;

  @override
  final DnsSensorEventType type;

  @override
  Stream<SensorEvent> get events => _events;

  @override
  @mustCallSuper
  void dispose() {
    _destroy.add(null);
    _destroy.close();
  }
}
