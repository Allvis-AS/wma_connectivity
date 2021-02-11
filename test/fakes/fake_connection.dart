import 'package:wma_connectivity/wma_connectivity.dart';

class FakeConnection extends Connection {
  FakeConnection(bool connected) : super(connected);

  @override
  String toString() => 'FakeConnection(connected: $connected)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FakeConnection && o.connected == connected;
  }

  @override
  int get hashCode => connected.hashCode;
}
