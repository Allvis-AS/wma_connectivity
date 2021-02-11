import 'package:meta/meta.dart';
import 'package:wma_connectivity/src/connection.dart';
import 'package:wma_connectivity/src/implementations/default_wma_connectivity.dart';
import 'package:wma_connectivity/src/sensor.dart';

abstract class WmaConnectivity {
  /// Constructs the default implementation of [WmaConnectivity].
  ///
  /// Make sure to re-use the same instance, preferably as a singleton in
  /// an IoC container.
  ///
  /// Example:
  /// ```
  /// WmaConnectivity(
  ///   sensors: [
  ///     ApiSensor(
  ///       uri: 'https://api.contoso.com/ping',
  ///       interval: const Duration(seconds: 10),
  ///       timeout: const Duration(seconds: 5),
  ///     ),
  ///     DnsSensor(
  ///       hosts: [
  ///         'cloudflare.com',
  ///         'google.com',
  ///         'microsoft.com',
  ///       ],
  ///       interval: const Duration(seconds: 10),
  ///       timeout: const Duration(seconds: 3),
  ///     )
  ///   ],
  ///   window: const Duration(seconds: 25),
  /// );
  /// ```
  factory WmaConnectivity({
    required List<Sensor> sensors,
    Duration window = const Duration(seconds: 30),
  }) =>
      DefaultWmaConnectivity(
        sensors: sensors,
        window: window,
      );

  /// Emits each time there's a status change in any of the connections.
  ///
  /// Emits only the connections that have had sensor events in the
  /// sampled window.
  ///
  /// Does not eagerly emit the first event, meaning you may need to use
  /// the `startWith()` operator to get the correct behavior, i.e. when
  /// using [StreamBuilder].
  ///
  /// If you wish to have an overview of all connections,
  /// then you'll have to build that functionality yourself upon this stream,
  /// i.e. with the `scan()` operator
  /// from [RxDart](https://pub.dev/packages/rxdart).
  Stream<List<Connection>> get connections;

  /// Closes the [connections] stream and calls `dispose()` on the [sensors].
  @mustCallSuper
  void dispose();
}
