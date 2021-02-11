import 'package:wma_connectivity/src/connection.dart';

class ApiConnection extends Connection {
  ApiConnection(bool connected) : super(connected);

  @override
  String toString() => 'ApiConnection(connected: $connected)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ApiConnection && o.connected == connected;
  }

  @override
  int get hashCode => connected.hashCode;
}
