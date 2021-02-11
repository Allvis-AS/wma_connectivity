import 'package:rxdart/rxdart.dart';
import 'package:wma_connectivity/src/connection.dart';
import 'package:wma_connectivity/src/sensor.dart';
import 'package:wma_connectivity/src/utils/wma_utils.dart';
import 'package:wma_connectivity/src/wma_connectivity.dart';

class DefaultWmaConnectivity implements WmaConnectivity {
  DefaultWmaConnectivity({
    required this.sensors,
    Duration window = const Duration(seconds: 30),
  }) {
    final types = sensors.map((s) => s.type).where((t) => !t.global).toSet();
    _connections = Rx.merge(sensors.map((s) => s.events))
        .slidingWindow(window, (e) => e.timestamp)
        .where((events) => events.isNotEmpty)
        .map((events) => types
            .where((t) => events.any((e) => e.type.global || e.type == t))
            .map((t) => t.create(wma(events
                .where((e) => e.type.global || e.type == t)
                .map((e) => e.value)
                .toList())))
            .toList())
        .takeUntil(_destroy)
        .publishReplay(maxSize: 1)
        .autoConnect();
  }

  final List<Sensor> sensors;
  final _destroy = PublishSubject<void>();
  late final Stream<List<Connection>> _connections;

  @override
  Stream<List<Connection>> get connections => _connections;

  @override
  void dispose() {
    _destroy.add(null);
    _destroy.close();
    sensors.forEach((s) => s.dispose());
  }
}

extension _StreamExtensions<T> on Stream<T> {
  Stream<List<T>> slidingWindow(
      Duration window, DateTime Function(T) selector) {
    return scan<List<T>>((acc, value, _) {
      final wall = DateTime.now().subtract(window);
      final test = (T value) => wall.isBefore(selector(value));
      return [
        ...acc!.where(test),
        if (test(value)) value,
      ];
    }, []);
  }
}
