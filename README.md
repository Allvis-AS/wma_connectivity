# wma_connectivity

Combines different sources of network events and
tries to estimate the connectivity of the device
using a Weighted Moving Average.

## Getting Started

```dart
class Conn extends StatefulWidget {
  const Conn({ Key key }) : super(key: key);

  @override
  _ConnState createState() => _ConnState();
}

class _ConnState extends State<Conn> {
  final wmaConnectivity = WmaConnectivity(
    sensors: [
      ApiSensor(
        uri: 'https://api.contoso.com/ping',
        interval: const Duration(seconds: 10),
        timeout: const Duration(seconds: 5),
      ),
      DnsSensor(
        hosts: [
          'cloudflare.com',
          'google.com',
          'microsoft.com',
        ],
        interval: const Duration(seconds: 10),
        timeout: const Duration(seconds: 3),
      )
    ],
    window: const Duration(seconds: 25),
  );

  @override
  void dispose() {
    wmaConnectivity.dispose(); // Remember to dispose of it once you no longer need it
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Connection>>(
      stream: wmaConnectivity.connections,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final connections = snapshot.data;
        // Examine the list of connections
        for (final conn in connections) {
          if (conn is DnsConnection && conn.connected) {
            // Do something interesting with the information...
          }else if (conn is ApiConnection && conn.connected) {
            // Do something even more interesting...
          }
        }
      }
    );
  }
}
```

## Custom sensors

If you want to, you can extend the library with
your own `Sensor` implementations.

All the types in this library are well documented,
so you should be able to take inspiration from the
existing `ApiSensor` and `DnsSensor` implementations.

### SocketException
You'll probably notice that there's a seemingly unused
`SensorEventType` called `SocketExceptionSensorEventType`.
It is there to make life easier, as most of the time you'll
want to listen to `SocketException` exceptions and add
those to the mix.

If you're using [dio](https://pub.dev/packages/dio), it's
as easy as creating an `Interceptor`, and listen for
the `SocketException` exceptions. Transform those into
a `Stream<SensorEvent>` with the `SensorEvent.socketException()`
factory helper method.

Like this:
```dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wma_connectivity/wma_connectivity.dart';

class SocketExceptionInterceptor extends Interceptor implements Sensor {
  SocketExceptionInterceptor();

  // This will serve as our event stream
  final _events = PublishSubject<SensorEvent>();

  @override
  Future onError(DioError err) async {
    if (err.type == DioErrorType.DEFAULT) {
      final error = err.error;
      if (error is SocketException) {
        // This is where we record the events
        _events.add(SensorEvent.socketException());
      }
    }
    return super.onError(err);
  }

  @override
  void dispose() {
    // Always remember to clean up 😉
    _events.close();
  }

  // Return the PublishSubject here
  @override
  Stream<SensorEvent> get events => _events;

  // Use the ready-to-go event type or make your own
  @override
  SensorEventType get type => const SocketExceptionSensorEventType(); 
}
```

And you're done!

## License

MIT