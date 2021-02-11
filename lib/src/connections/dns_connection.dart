import 'package:wma_connectivity/src/connection.dart';

class DnsConnection extends Connection {
  DnsConnection(bool connected) : super(connected);

  @override
  String toString() => 'DnsConnection(connected: $connected)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DnsConnection && o.connected == connected;
  }

  @override
  int get hashCode => connected.hashCode;
}
